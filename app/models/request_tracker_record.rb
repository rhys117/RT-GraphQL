class RequestTrackerRecord < ApplicationRecord
  self.abstract_class = true
  establish_connection :request_tracker

  NOT_RESOLVED_STATUSES = %w(resolved rejected deleted).freeze

  scope :like, ->(field, value) { where arel_table[field].matches("%#{value}%") }
end
