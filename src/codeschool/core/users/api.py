from codeschool.api import router
from django.conf.urls import url

from . import views

router.register(r'users', views.UserViewSet,base_name="users")
router.register(r'detail', views.UserDetailViewSet)
router.register(r'change_password',views.ChangePasswordViewSet,base_name="change-password")
