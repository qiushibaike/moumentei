role = Role.find_or_create_by_name 'admin'
admin = User.find_or_create_by_login 'admin'
admin.email = 'admin@bling0.com'
admin.password='123456'
admin.password_confirmation='123456'
admin.state = 'active'
admin.roles << role rescue nil
admin.save
group = Group.find_or_create_by_name 'youwenti'
group.alias = 'youwenti'
group.save
#Sinatrack.comments
