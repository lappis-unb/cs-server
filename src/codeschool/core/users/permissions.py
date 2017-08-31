from rest_framework.permissions import BasePermission

# https://github.com/HazyResearch/elementary/blob/master/django/resources/views.py

class IsAdminOrSelf(BasePermission):
    def has_permission(self, request, view):
        if not request.user or not request.user.is_authenticated():
            return False
        if not request.user.is_staff:
            return request.method in ['GET', 'HEAD', 'OPTIONS', 'PUT']
        return True

    def has_object_permission(self, request, view, obj):
        if request.user.is_staff:
            return True
        return request.user == obj
