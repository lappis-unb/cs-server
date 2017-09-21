from rest_framework import serializers
from rest_framework.decorators import detail_route, list_route
from django.contrib.auth.hashers import make_password
from . import models


class ProfileSerializer(serializers.ModelSerializer):


    class Meta:
        model = models.Profile
        fields = ('gender','phone','website','date_of_birth',
        'website','about_me', 'visibility','user')

        read_only = {'read_only':True}
        extra_kwargs = {"user":read_only}

class CreateUserSerializer(serializers.ModelSerializer):
    """
    Serialize User objects.
    """

    role = serializers.SerializerMethodField()
    profile = ProfileSerializer()
    password_confirmation = serializers.CharField(write_only=True)

    class Meta:
        model = models.User
        fields = ('username', 'alias', 'role','email', 'name', 'school_id','password','password_confirmation', 'profile')
        write_only = {'write_only': True}
        read_only = {'read_only':True}



        extra_kwargs = {
                'password':write_only,
                'profile':write_only,
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
        validated_data['password'] = validated_data['password']
        password_confirmation = validated_data.pop('password_confirmation', None)
        if(password_confirmation == validated_data['password']):
            validated_data['password'] = make_password(validated_data['password'])
        else:
            raise serializers.ValidationError("I guess you didn't type the password confirmation just like the password")
        profile_data = validated_data.pop('profile')
        user = super(CreateUserSerializer,self).create(validated_data)
        self.update_or_create_profile(user,profile_data)
        return user

    def update_or_create_profile(self, user, profile_data):
        # This always creates a Profile if the User is missing one;
        # change the logic here if that's not right for your app
        models.Profile.objects.update_or_create(user=user, defaults=profile_data)



class UserSerializer(serializers.HyperlinkedModelSerializer):

    class Meta:
        model = models.User
        fields = ('url',)



class UserDetailSerializer(serializers.ModelSerializer):
    """
    Serialize User objects.
    """

    role = serializers.SerializerMethodField()
    profile = ProfileSerializer()

    class Meta:
        model = models.User
        fields = ('username', 'alias', 'role','email', 'name', 'school_id', 'profile')
        write_only = {'write_only': True}
        read_only = {'read_only':True}



        extra_kwargs = {
                'profile':write_only,
                'school_id':read_only,
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
        validated_data['password'] = make_password(validated_data['password'])
        profile_data = validated_data.pop('profile')
        user = super(UserDetailSerializer,self).create(validated_data)
        self.update_or_create_profile(user,profile_data)
        return user

    def update_or_create_profile(self, user, profile_data):
        # This always creates a Profile if the User is missing one;
        # change the logic here if that's not right for your app
        models.Profile.objects.update_or_create(user=user, defaults=profile_data)

    def update(self, instance, validated_data):


        profile_data = validated_data.pop('profile')
        profile = instance.profile

        instance.alias = validated_data.get('alias')
        instance.email = validated_data.get('email')
        instance.name = validated_data.get('name')

        instance.profile.gender = profile_data.get('gender')
        instance.profile.phone = profile_data.get('phone')
        instance.profile.date_of_birth = profile_data.get('date_of_birth')
        instance.profile.about_me = profile_data.get('about_me')
        instance.profile.website = profile_data.get('website')


        instance.save()
        profile.save()

        return instance


class FullUserSerializer(serializers.ModelSerializer):
    """
    Serialize full User objects.
    """

    # TODO: extra_emails
    # TODO: create hyperlinks or make it role-based access?

    class Meta:
        model = models.User
        fields = ('url', 'alias', 'name', 'role', 'email', 'school_id')
