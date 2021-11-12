
class Movie < ActiveRecord::Base
    def self.all_ratings
      ['G', 'PG', 'PG-13', 'R']
    end
    
    def self.with_ratings(ratings, sort_by)
      if ratings.nil?
        all.order sort_by
      else
        where(rating: ratings.map(&:upcase)).order sort_by
      end
    end
  
    def self.find_in_tmdb(search_terms)
      not_saved = Array.new
      if search_terms[:release_year] != nil
        uri = 'https://api.themoviedb.org/3/search/movie?api_key=df5790e35919003510561ebb5b0561df&query=' + search_terms[:title] + '&language=' + search_terms[:language] + '&year=' + search_terms[:release_year]
      else
        uri = 'https://api.themoviedb.org/3/search/movie?api_key=df5790e35919003510561ebb5b0561df&query=' + search_terms[:title] + '&language=' + search_terms[:language]
      end
      untouched = Faraday.get URI::escape(uri)
      touched = JSON.parse(untouched.body)
      movies = touched['movies']
      [*0..movies.length-1].each do |m|
        nm = Movie.new
        elem = movies[m]
        nm.rating = "R"
        nm.title = elem["title"]
        nm.release_date = elem["release_date"]
        nm.description = elem["description"]
        not_saved.append(nm)
      end
      return not_saved
    end
    def self.find_in_tmdb(string)
      Faraday.get(string)
    end
end