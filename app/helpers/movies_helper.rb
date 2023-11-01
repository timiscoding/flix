module MoviesHelper
  def total_gross(movie)
    movie.flop? ? 'Flop!' : number_to_currency(movie.total_gross, precision: 0)
  end

  def year_of(movie)
    movie.released_on.strftime('%Y')
  end

  def average_stars(movie)
    average_stars = movie.average_stars
    if average_stars.zero?
      content_tag 'b', 'No reviews'
    else
      # pluralize(number_with_precision(average_stars, precision: 1), 'star')
      '*' * average_stars.to_i
    end
  end

  def nav_link_to(name, url)
    link_to name, url, class: current_page?(url) ? 'active' : ''
  end

  def main_image(movie)
    if movie.main_image.attached?
      image_tag movie.main_image.variant(resize_to_limit: [300, nil])
    else
      image_tag 'placeholder.png'
    end
  end
end
