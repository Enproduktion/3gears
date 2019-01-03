# Copyright (C) 2017 Enproduktion GmbH
#
# This file is part of 3gears.
#
# 3gears is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

require "find"
require_relative "app_config"
require_relative "s3"
require_relative "s3upload_worker"

class Fileserver
  def self.get_upload_ticket(size)
    size > 0 or raise ParameterError, "invalid size"

    id = generate_id
    IO::write(get_ticket_path(id), size)

    id
  end

  def self.delete_upload_ticket(id)
    ticket_path = get_ticket_path(id)
    uploading_path = get_uploading_path(id)

    File.exists?(ticket_path) or raise NotFound, "ticket not found"

    File.unlink(ticket_path)
    File.unlink(uploading_path) if File.exists?(uploading_path)
  end

  def self.move_file(id, new_storage)
    storage_link_path = get_storage_link_path(id)

    if File.exists?(storage_link_path)
      move_file_from(File.readlink(storage_link_path), id, new_storage)
    else # try upload directory
      ticket_path = get_ticket_path(id)
      uploading_path = get_uploading_path(id)

      File.exists?(ticket_path) or raise NotFound, "neither file nor ticket found"
      File.exists?(uploading_path) or raise NotFound, "uploaded file not found"

      File.open(ticket_path, "r") do |ticket_file|
        ticket_file.flock(File::LOCK_EX | File::LOCK_NB) or raise Locked, "upload running"
        File.unlink(ticket_path)
      end

      move_file_from(uploading_path, id, new_storage)
    end
  end

  def self.move_file_from(path, id, new_storage)
    storage_link_path = get_storage_link_path(id)
    new_storage_path = get_storage_path(new_storage, id) or raise NotFound, "destination not found"

    File.rename(path, new_storage_path)
    File.unlink(storage_link_path) if File.exists?(storage_link_path)
    File.symlink(new_storage_path, storage_link_path)
  end

  def self.publish_file(id, name)
    storage_link_path = get_storage_link_path(id)

    File.exists?(storage_link_path) or raise NotFound, "file not found"

    if S3.active
      storage_path = File.readlink(storage_link_path)

      if File.directory?(storage_path)
        # uploading images sequences disabled
        # Find.find("#{storage_path}/") do |filepath|
        #   ending = filepath[storage_path.length..-1]
        #   $stderr.write "#{filepath} -> #{id}/#{name}#{ending}\n"
        #   if File.file?(filepath)
        #     Resque.enqueue(S3UploadWorker, filepath, "#{id}/#{name}#{ending}")
        #   end
        # end
      else
        Resque.enqueue(S3UploadWorker, storage_path, "#{id}/#{name}")
      end
    end

    Dir.mkdir(get_public_dir(id))
    File.symlink(storage_link_path, get_public_path(id, name))
  end

  def self.trash_file(id)
    storage_link_path = get_storage_link_path(id)

    File.exists?(storage_link_path) or raise NotFound, "file not found"

    storage_path = File.readlink(storage_link_path)
    public_dir = get_public_dir(id)

    Dir.glob(public_dir + "/*").each { |path| File.unlink(path) }
    Dir.unlink(public_dir)

    File.rename(storage_path, get_trash_path(id))
    File.unlink(storage_link_path)
  end

  def self.get_ticket_path(id)
    assert_valid_file_id(id)
    AppConfig.get["tickets_directory"] + "/" + id
  end

  def self.get_uploading_path(id)
    assert_valid_file_id(id)
    AppConfig.get["uploader_directory"] + "/" + id
  end

  def self.get_storage_link_path(id)
    assert_valid_file_id(id)
    AppConfig.get["storage_links_directory"] + "/" + id
  end

  def self.get_trash_path(id)
    assert_valid_file_id(id)
    AppConfig.get["trash_directory"] + "/" + id
  end

  def self.get_storage_path(storage, id)
    assert_valid_file_id(id)
    storage_dir = AppConfig.get["storage_directories"][storage] or return
    storage_dir + "/" + id
  end

  def self.get_public_dir(id)
    assert_valid_file_id(id)
    AppConfig.get["public_directory"] + "/" + id
  end

  def self.get_public_path(id, name)
    assert_valid_file_id(id)
    assert_valid_filename(name)
    AppConfig.get["public_directory"] + "/" + id + "/" + name
  end

  def self.storage_exits?(storage)
    !!AppConfig.get["storage_directories"][storage]
  end

  def self.assert_valid_file_id(id)
    valid_token?(id) or raise ParameterError, "invalid file id"
  end

  def self.assert_valid_filename(name)
    valid_filename?(name) or raise ParameterError, "invalid filename"
  end

  def self.valid_token?(token)
    /^[\w]{1,255}$/ =~ token
  end

  def self.valid_filename?(name)
    /^[^\/\0]+$/ =~ name && name.encode("UTF-8").bytesize <= 255
  end

  def self.generate_id
    SecureRandom.hex
  end
end

class Fileserver::Error < StandardError
end

class Fileserver::ParameterError < Fileserver::Error
end

class Fileserver::NotFound < Fileserver::Error
end

class Fileserver::Locked < Fileserver::Error
end
