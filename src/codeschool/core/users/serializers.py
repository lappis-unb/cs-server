from rest_framework import serializers

from . import models


class UserSerializer(serializers.HyperlinkedModelSerializer):
    """
    Serialize User objects.
    """

    role = serializers.SerializerMethodField()

    class Meta:
        model = models.User
        fields = ('url', 'alias', 'role')

    def get_role(self, obj):
        if(obj.role == models.User.ROLE_STUDENT):
            return 'student'
        elif(obj.role == models.User.ROLE_TEACHER):
            return 'teacher'
        elif(obj.role == models.User.ROLE_STAFF):
            return 'staff'
        elif(obj.role == models.User.ROLE_ADMIN):
            return 'admin'


class FullUserSerializer(serializers.ModelSerializer):
    """
    Serialize full User objects.
    """

    # TODO: extra_emails
    # TODO: create hyperlinks or make it role-based access?

    class Meta:
        model = models.User
        fields = ('url', 'alias', 'name', 'role', 'email', 'school_id')


class ProfileSerializer(serializers.HyperlinkedModelSerializer):
    """
    Serialize user profiles
    """

    # TODO: hyperlinks as sub-resource under each user
    # TODO: add extra user fields?
    # TODO: nullify fields that user is not allowed to see? (this may be
    # expensive in querysets)

    class Meta:
        model = models.Profile
