class MoviesService
  def search(keyword)
    connection.get('3/search/movie') do |faraday|
      faraday.params['query'] = keyword
    end
  end

  def top_rated
    connection.get('3/movie/top_rated')
  end

  def find_movie(id)
    connection.get("3/movie/#{id}") do |f|
      f.params['append_to_response'] = 'reviews,credits'
    end
  end

  private

  def connection
    Faraday.new('https://api.themoviedb.org/') do |faraday|
      faraday.params['api_key'] = Rails.application.credentials.tmdb_movies[:key]
    end
  end
end
