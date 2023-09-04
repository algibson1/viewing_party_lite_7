class MoviesService
  def search(keyword)
    response = connection.get('3/search/movie') do |faraday|
      faraday.params['query'] = keyword
    end
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def top_rated
    response = connection.get('3/movie/top_rated')
    JSON.parse(response.body, symbolize_names: true)[:results]
  end

  def find_movie(id)
    response = connection.get("3/movie/#{id}") do |f|
      f.params['append_to_response'] = 'reviews,credits'
    end
    Movie.new(JSON.parse(response.body, symbolize_names: true))
  end

  private

  def connection
    Faraday.new('https://api.themoviedb.org/') do |faraday|
      faraday.params['api_key'] = Rails.application.credentials.tmdb_movies[:key]
    end
  end
end
