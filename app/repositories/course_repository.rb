module CourseRepository
  extend ActiveSupport::Concern
  include Concerns::StateMachine

  included do
    has_many :sorted_lessons, -> { order(start: :asc) }, class_name: "Course::Lesson", inverse_of: :course

    scope :web, -> { published.joins(:company).merge(Company.active) }

    scope :nearest, -> { select("courses.*, min(course_lessons.start) as nearest_lesson_datetime") \
                         .published.joins(:lessons) \
                         .where('course_lessons.start >= ?', Time.current) \
                         .group("course_lessons.course_id, #{self.columns_list}") \
                         .order('nearest_lesson_datetime asc')}
  end
end
