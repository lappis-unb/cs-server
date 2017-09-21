from codeschool.api import router
from . import views

router.register(r'users', views.UserViewSet,base_name="users")
router.register(r'users/(?P<pk>[0-9]+)/classrooms', views.UserViewSet.classrooms, base_name="users_classrooms")
router.register(r'profile', views.ProfileViewSet)
