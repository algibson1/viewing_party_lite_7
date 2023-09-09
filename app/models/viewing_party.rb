class ViewingParty < ApplicationRecord
  include Rails.application.routes.url_helpers
  has_many :party_guests
  has_many :users, through: :party_guests
  validates :movie_id, presence: true
  validates :duration, presence: true, numericality: true, comparison: { greater_than_or_equal_to: :movie_duration }
  validates :party_date, presence: true,
                  timeliness: { on_or_after: Date.today, type: :date, message: 'cannot be in the past' }
  validates :start_time, presence: true
  validate :future_start_time

  def movie
    @movie ||= MoviesFacade.new.find_movie(movie_id)
  end

  def movie_duration
    movie.runtime
  end

  def movie_image
    if movie.image
      "https://image.tmdb.org/t/p/w500#{movie.image}"
    end
  end

  def movie_title
    movie.title
  end

  def users
    User.joins(:party_guests).where('party_guests.viewing_party_id = ?', id)
  end
  # users association was not working- unknown reasoning. Had to write manually

  def send_invites(host_id, guests_hash)
    PartyGuest.create(viewing_party: self, user_id: host_id, host: true)
    guests_hash.each do |id, invite_status|
      PartyGuest.create(viewing_party: self, user_id: id.to_i, host: false) if invite_status == '1'
    end
  end

  def host
    users.joins(:party_guests).find_by('party_guests.host = ?', true)
  end

  def invitees
    users.joins(:party_guests).where('party_guests.host = ?', false)
  end

  def invitee_names
    invitees.map { |invitee| invitee.name }
  end

  private

  def future_start_time
    return false if party_date.nil? || start_time.nil?
    return true if party_date > Date.today
    if start_time.strftime("%H:%M") < Time.now.strftime("%H:%M")
      errors.add(:start_time, 'cannot be in the past')
    end
  end
end