class Movie
  attr_reader :id,
              :title,
              :rating,
              :runtime,
              :genres,
              :summary,
              :cast,
              :total_reviews,
              :reviews,
              :image

  def initialize(data)
    @id = data[:id]
    @title = data[:title]
    @image = data[:backdrop_path]
    @rating = data[:vote_average]
    @runtime = data[:runtime]
    @genres = data[:genres] ? format_genres(data[:genres]) : 'Unknown'
    @summary = data[:overview]
    @cast = data.dig(:credits, :cast) ? generate_cast(data[:credits][:cast]) : []
    @total_reviews = data.dig(:reviews, :total_results) || 0
    @reviews = data.dig(:reviews, :results) ? generate_reviews(data[:reviews][:results]) : []
  end

  def format_genres(genres)
    genres.map { |genre| genre[:name] }.join(', ')
  end

  def generate_cast(cast)
    cast.map { |cast_member| CastMember.new(cast_member) }[0..9]
  end

  def generate_reviews(reviews)
    reviews.map { |review| Review.new(review) }
  end

  def format_runtime
    "#{@runtime / 60}hr #{@runtime % 60}min"
  end
end
