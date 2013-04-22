# -*- encoding : utf-8 -*-
group = Group.find_or_create_by_name 'youwenti'
group.alias = 'youwenti'
group.domain ||= 'localhost'
group.save(:validate => false)
Setting.default_group = group.id
role = Role.find_or_create_by_name 'admin'
admin = User.find_or_create_by_login 'admin'
admin.email = 'admin@bling0.com'
admin.password='123456'
admin.password_confirmation='123456'
admin.state = 'active'
admin.save!
admin.roles << role rescue nil
article = group.articles.build
article.status = 'publish'
article.title = '这是第一篇'
article.user = admin
article.content = <<CONTENT
您可以登录后台 /admin
用户名admin
密码123456
CONTENT
article.save(:validate => false)
comment = article.comments.build
comment.user = admin
comment.content = '测试服务器会每天重置数据库'
comment.status = 'publish'
comment.anonymous = false
comment.save(:validate => false)
