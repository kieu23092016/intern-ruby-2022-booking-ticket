class ShowTime < ApplicationRecord
  has_many :seats, dependent: :restrict_with_exception
  belongs_to :movie
  belongs_to :room

  validate :valid_change, on: :update
  validate :valid_overlap_showtime
  before_validation :valid_format_showtime

  delegate :cinema_name, to: :room
  delegate :title, to: :movie, prefix: :movie
  delegate :name, to: :room, prefix: :room

  scope :find_room, ->(room_id){where "room_id = ?", room_id}
  scope :overlap, lambda {|start_time, end_time|
                    where "((start_time < ? AND end_time > ?)
                            OR (end_time > ? AND start_time < ?)
                            OR (start_time = ? AND end_time = ?))",
                          end_time, end_time, start_time,
                          start_time, start_time, end_time
                  }
  scope :filter_date, lambda{|movie_id, date|
                        where "(movie_id = ? AND start_time BETWEEN ? AND ? )",
                              movie_id,
                              date.to_datetime.beginning_of_day,
                              date.to_datetime.end_of_day
                      }

  def valid_overlap_showtime
    return if ShowTime.find_room(room_id).overlap(start_time, end_time).blank?

    errors.add(:start_time, message: I18n.t("time_overlap"))
  end

  def valid_format_showtime
    if start_time.presence
      self.end_time = start_time + movie.duration_min.minutes
      return true if start_time > Time.current
    else
      errors.add(:start_time, message: I18n.t("time_ignore"))
      return false
    end

    errors.add(:start_time, message: I18n.t("time_invalid"))
  end

  def valid_change
    return if seats.blank?

    errors.add(:seats, message: I18n.t("seats"))
  end
end
