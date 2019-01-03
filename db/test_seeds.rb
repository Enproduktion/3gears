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

User.create!({
  username: "",
  password: "",
  password_confirmation: "",
  email: "nothing@nothing.not",
  role: "user",
  confirmed: true,
  hidden: true,
})
User.create({
  username: "awyeah",
  password: "awyeah",
  password_confirmation: "awyeah",
  email: "awyeah@nothing.not",
  role: "user",
  confirmed: true,
  hidden: true,
})
User.create({
  username: "",
  password: "",
  password_confirmation: "",
  email: "",
  role: "",
  confirmed: true,
})
MovieOrIdea.create({
  user: User.default_user,
  is_idea: true,
})
MovieOrIdea.create({
  user: User.default_user,
  is_idea: false,
})
MovieOrIdea.create({
  user: User.default_user,
  title: "3dox",
  is_idea: true,
})
MovieOrIdea.create({
  user: User.default_user,
  title: "soccer",
  is_idea: false,
})
MovieOrIdea.create({
   user: User.find_by_username_or_email('awyeah'),
   title: "other user",
   is_idea: false,
 })

Specification.create({
  spec: "Monitor",
  value: "2",
  specable: MovieOrIdea.first
})

Organisation.create({
  name: "3gears Org",
  user: User.default_user,
  confirmed: true
})
Footage.create!({
  user: User.default_user,
  title: "bratislava"
})
Footage.create({
  user: User.default_user,
})
Footage.create({
  user: User.default_user,
})
Footage.create({
  user: User.default_user,
})


tag = Tag.create!({
                name: 'testtag'
            })

Footage.first.tags << tag

User.create!({
  username: "orb",
  password: "orborb",
  password_confirmation: "orborb",
  email: "orb@orb.orb",
  role: "editor",
  confirmed: true,
})
User.create!({
  username: "bra",
  password: "brabra",
  password_confirmation: "brabra",
  email: "bra@bra.bra",
  role: "editor",
  confirmed: true,
})

Document.create({
  movie_or_idea: MovieOrIdea.first,
  document: File.new("#{Rails.root}/spec/fixtures/file.pdf")
})

Medium.create!({
  medium_use: 'original',
  referer: MovieOrIdea.first
})

article = Article.create(viewable_by_all: Article.viewable['Public'], published_at: Time.now, user_id: User.where(role: "editor").first.id)
article.article_contents.create(locale: :en, title: "Welcome to 3dox", abstract: "Welcome", body: Faker::Lorem.paragraph(20))
article = Article.create(viewable_by_all: Article.viewable['Public'], published_at: Time.now, user_id: User.where(role: "editor").first.id)
article.article_contents.create(locale: :en, title: "Hello to 3dox", abstract: "Welcome", body: Faker::Lorem.paragraph(20))
article = Article.create(viewable_by_all: Article.viewable['Public'], published_at: Time.now, user_id: User.where(role: "editor").first.id)
article.article_contents.create(locale: :en, title: "Say Hello to 3dox", abstract: "Welcome", body: Faker::Lorem.paragraph(20))
