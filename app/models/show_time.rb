class ShowTime < ApplicationRecord
  has_many :seats, dependent: :destroy
  belongs_to :movie
  belongs_to :room

  validate :valid_overlap_showtime
  before_validation :valid_format_showtime

  scope :find_room, ->(room_id){where "room_id = ?", room_id}
  scope :overlap, lambda {|start_time, end_time|
                    where "((start_time < ? AND end_time > ?)
                            OR (end_time > ? AND start_time < ?)
                            OR (start_time = ? AND end_time = ?))",
                          end_time, end_time, start_time,
                          start_time, start_time, end_time
                  }

  def valid_overlap_showtime
    return if ShowTime.find_room(room_id).overlap(start_time, end_time).blank?

    errors.add(:start_time, message: I18n.t("time_overlap"))
  end

  def valid_format_showtime
    if start_time.presence
      self.end_time = start_time + movie.duration_min.minutes
      return if start_time > Time.current
    else
      errors.add(:start_time, message: I18n.t("time_ignore"))
      return false
    end

    errors.add(:start_time, message: I18n.t("time_invalid"))
  end
end
