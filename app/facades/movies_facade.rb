class MoviesFacade
  attr_reader :_cached_movies

  def initialize
    @_cached_movies = {}
  end

  def find_movie(id)
    @_cached_movies[id] ||= get_movie(id)
  end

  def movies_list(query_term)
    return formatted(top_rated) if query_term == 'top_rated'
    formatted(search(query_term))
  end
  
  private
  def service
    @_service = MoviesService.new
  end

  def get_movie(id)
    response = service.find_movie(id)
    Movie.new(JSON.parse(response.body, symbolize_names: true))
  end

  def top_rated
    @_top_rated ||= service.top_rated
  end

  def search(query_term)
    service.search(query_term)
  end

  def formatted(response)
    movie_data = JSON.parse(response.body, symbolize_names: true)[:results]
    movie_data.map { |data| Movie.new(data) }
  end
end
