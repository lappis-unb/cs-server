from rest_framework.permissions import BasePermission
from .models import *
from .views import *

class IsAdminOrSelf(BasePermission):
    def has_permission(self, request, view):

        if not request.user or not request.user.is_authenticated():
            return False
        if not request.user.is_staff:
            all_info = view.queryset
            owner_user_id = request.user.id
            owner_user_info = User.objects.filter(id=owner_user_id)
            view.queryset = owner_user_info
            return request.method in ['GET', 'HEAD', 'OPTIONS', 'PUT']
        return True

    def has_object_permission(self, request, view, obj):
        print("haso")
        if request.user.is_staff:
            return True
        return request.user == obj
