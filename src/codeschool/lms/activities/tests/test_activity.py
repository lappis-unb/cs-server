import mock
import pytest
from django.contrib.auth.models import User
from django.core.exceptions import ImproperlyConfigured, ValidationError
from django.db.models import QuerySet
from mock import patch, Mock

from codeschool.lms.activities.models import Activity, Submission, Feedback, \
    Progress
from codeschool.lms.activities.tests.fixtures import Fixtures
from codeschool.lms.activities.tests.mocks import wagtail_page, submit_for, \
    queryset_mock


class TestActivity(Fixtures):
    """
    Abstract tests for activities.
    """

    # Test valid configuration
    def _check_valid_child_class(self, name, base_class):
        activity_class = self.activity_class
        child_class = getattr(activity_class, '%s_class' % name)
        assert child_class is not None

        if activity_class is not Activity:
            assert child_class is not base_class
            assert activity_class._meta.abstract == child_class._meta.abstract

    def test_activity_has_a_valid_progress_class(self):
        self._check_valid_child_class('progress', Progress)

    def test_activity_has_a_valid_submission_class(self):
        self._check_valid_child_class('submission', Submission)

    def test_activity_has_a_valid_feedback_class(self):
        self._check_valid_child_class('feedback', Feedback)

    # Test error behaviors
    def test_cannot_submit_on_closed_or_disabled_activity(self, activity):
        activity.closed = True
        with pytest.raises(RuntimeError):
            activity.submit(request=Mock())

        activity.closed = False
        activity.disabled = True
        with pytest.raises(RuntimeError):
            activity.submit(request=Mock())

    def test_cannot_submit_if_submission_class_is_not_defined(self,
                                                              activity):
        activity.submission_class = None

        with pytest.raises(ImproperlyConfigured):
            activity.submit(request=Mock())

    def test_cannot_clean_disabled_activity(self, activity):
        with wagtail_page(self.activity_class):
            activity.disable('error')

        with pytest.raises(ValidationError):
            activity.clean()

    # Test happy stories: user submissions
    def test_submit_payload(self, activity, user, progress):
        request = Mock(user=user)
        for_user = lambda user: progress
        cls = self.activity_class

        with patch.object(cls, 'progress_set', Mock(for_user=for_user)), \
             submit_for(cls):
            sub = activity.submit(request, **self.submission_payload)

        assert isinstance(sub, Submission)
        assert sub.activity is activity

    def test_submit_with_user_kwargs(self, activity):
        request = Mock()
        with patch.object(self.activity_class, 'submit', Mock()) as submit:
            payload = dict(self.submission_payload, probably_invalid_arg=42)
            activity.submit_with_user_payload(request, payload)

        assert submit.call_args == mock.call(request, **self.submission_payload)

    def test_submissions_property_yields_a_queryset(self, activity):
        if self.submission_class._meta.abstract:
            return

        with queryset_mock():
            submissions = activity.submissions
            assert isinstance(submissions, QuerySet)

    def test_clean_activity(self, activity):
        activity.owner = User(username='user', first_name='John',
                              last_name='Smith', email='foo@bar.com')
        activity.clean()
        assert activity.author_name == 'John Smith <foo@bar.com>'
