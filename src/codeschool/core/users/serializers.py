from rest_framework import serializers
from rest_framework.decorators import detail_route, list_route
from django.contrib.auth.hashers import make_password
from . import models
from .permissions import IsAdminOrSelf

class ProfileSerializer(serializers.ModelSerializer):
    """
    Serialize user profiles
    """

    # TODO: hyperlinks as sub-resource under each user
    # TODO: add extra user fields?
    # TODO: nullify fields that user is not allowed to see? (this may be
    # expensive in querysets)


    class Meta:
        model = models.Profile
        fields = (
        'gender','phone','date_of_birth'
        ,'website','about_me', 'visibility', 'user'
        )
        read_only = {'read_only': True}
        extra_kwargs = {
                'user':read_only
        }


class UserSerializer(serializers.ModelSerializer):
    """
    Serialize User objects.
    """

    role = serializers.SerializerMethodField()
    #password_confirmation = serializers.CharField(write_only=True)
    password_confirmation = serializers.CharField(write_only=True)

    class Meta:
        model = models.User
        fields = ('alias', 'role','email', 'name', 'school_id', 'password', 'password_confirmation')
        write_only = {'write_only': True}
        extra_kwargs = {
                'email': write_only,
                'role': write_only,
                'name': write_only,
                'school_id': write_only,
                'password': write_only,
                # 'profile':write_only,
                'password_confirmation': write_only
        }

    def get_role(self, obj):
        if(obj.role == models.User.ROLE_STUDENT):
            return 'student'
        elif(obj.role == models.User.ROLE_TEACHER):
            return 'teacher'
        elif(obj.role == models.User.ROLE_STAFF):
            return 'staff'
        elif(obj.role == models.User.ROLE_ADMIN):
            return 'admin'

    def create(self, validated_data):
        password_confirmation = validated_data.pop('password_confirmation', None)
        if(password_confirmation == validated_data['password']):
            return super(UserSerializer, self).create(validated_data)
        else:
            raise Exception()


    # def create(self, validated_data):
    #     profile_data = validated_data.pop('profile',None)
    #     user = models.User.objects.create(**validated_data)
    #     models.Profile.create(user=user, **profile_data)
    #     return user


    '''def update(self, instance, validated_data):

        #,'website','about_me', 'visibility'
        profile_data = validated_data.pop('profile')
        profile = instance.profile
        instance.email = validated_data.get('email',instance.email)
        instance.role = validated_data.get('role',instance.role)
        instance.name = validated_data.get('name',instance.name)
        #profile = instance.profile
        #instance.gender = validated_data.get('gender', instance.gender)
        #instance.phone = validated_data.get('phone', instance.phone)
        #instance.date_of_birth = validated_data('date_of_birth',instance.date_of_birth)
        instance.save()
        profile.save()
        #profile.save()

        return instance'''



    '''def create(self, validated_data):
        password_confirmation = validated_data.pop('password_confirmation', None)
        if(password_confirmation == validated_data['password']):
            validated_data['password'] = make_password(validated_data['password'])
            return super(UserSerializer, self).create(validated_data)
        else:
            raise Exception()'''


class FullUserSerializer(serializers.ModelSerializer):
    """
    Serialize full User objects.
    """

    # TODO: extra_emails
    # TODO: create hyperlinks or make it role-based access?

    class Meta:
        model = models.User
        fields = ('url', 'alias', 'name', 'role', 'email', 'school_id')
