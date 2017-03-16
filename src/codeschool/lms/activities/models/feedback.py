from django.core.exceptions import ImproperlyConfigured
from django.utils.translation import ugettext_lazy as _, ugettext as __
from lazyutils import lazy

from codeschool import models
from codeschool.lms.activities.models import HasProgressMixin
from codeschool.lms.activities.models.validators import grade_validator
from pyml import p


class Feedback(HasProgressMixin,
               models.TimeStampedModel,
               models.PolymorphicModel):
    """
    Feedback for user.

    Usually there will be one get_feedback per submission, but this figure may
    vary from case to case.
    """

    MESSAGE_OK = _(
        '*Congratulations!* Your response is correct!'
    )
    MESSAGE_OK_WITH_PENALTIES = _(
        'Your response is correct, but you did not achieved the maximum grade.'
    )
    MESSAGE_WRONG = _(
        'I\'m sorry. Wrong response response!'
    )
    MESSAGE_PARTIAL = _(
        'Your answer is partially correct: you achieved %(grade)d%% of '
        'the total grade.'
    )
    MESSAGE_NOT_GRADED = _(
        'Your response has not been graded yet!'
    )

    submission = models.OneToOneField('Submission', related_name='get_feedback')
    manual_grading = models.BooleanField(
        default=True,
        help_text=_(
            'True if get_feedback was created manually by a human.'
        )
    )
    grader_user = models.ForeignKey(
        models.User, blank=True, null=True,
        help_text=_(
            'User that performed the manual grading.'
        )
    )
    given_grade_pc = models.DecimalField(
        _('percentage of maximum grade'),
        help_text=_(
            'This grade is given by the auto-grader and represents the grade '
            'for the response before accounting for any bonuses or penalties.'
        ),
        max_digits=6,
        decimal_places=3,
        validators=[grade_validator],
        blank=True,
        null=True,
    )
    final_grade_pc = models.DecimalField(
        _('final grade'),
        help_text=_(
            'Similar to given_grade, but can account for additional factors '
            'such as delay penalties or for any other reason the teacher may '
            'want to override the student\'s grade.'
        ),
        max_digits=6,
        decimal_places=3,
        validators=[grade_validator],
        blank=True,
        null=True,
    )
    is_correct = models.BooleanField(default=False)
    progress = lazy(lambda x: x.submission.progress)

    def autograde(self):
        """
        Compute and set self.given_grade.

        This function may change other states in the get_feedback object, depending
        on the activity.
        """

        name = self.__class__.__name__
        raise ImproperlyConfigured(
            'Class %s must implement the .autograde() method.' % name
        )

    def update_final_grade(self):
        """
        Compute final grade applying all possible penalties and bonuses.
        """

        self.final_grade_pc = self.given_grade_pc
        if self.given_grade_pc == 100:
            self.is_correct = True

    def render_message(self, **kwargs):
        """
        Renders get_feedback message.
        """

        if self.is_correct and self.final_grade_pc >= self.given_grade_pc:
            msg = self.MESSAGE_OK
        elif self.is_correct and self.final_grade_pc < self.given_grade_pc:
            msg = self.MESSAGE_OK_WITH_PENALTIES
        elif not self.is_correct and self.given_grade_pc > 0:
            msg = self.MESSAGE_PARTIAL
        else:
            msg = self.MESSAGE_WRONG
        return p(msg, cls='cs-get_feedback-message').render(**kwargs)
