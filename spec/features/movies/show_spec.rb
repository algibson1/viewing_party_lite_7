require 'rails_helper'

RSpec.describe 'Movie Details (Show) Page', :vcr do
  it 'has buttons to create a viewing party or go back to discover' do
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com')
    movie = MoviesFacade.new.find_movie(234)
    visit user_movie_path(ally, movie.id)

    expect(page).to have_button('Discover Page')
    click_button('Discover Page')
    expect(current_path).to eq(user_discover_path(ally))
  end

  it 'has a button to create a viewing party' do
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com')
    movie = MoviesFacade.new.find_movie(234)
    visit user_movie_path(ally, movie.id)

    expect(page).to have_button("Create A Viewing Party For #{movie.title}")
    click_button("Create A Viewing Party For #{movie.title}")
    expect(current_path).to eq(new_user_movie_viewing_party_path(ally, movie.id))
  end

  it "has all the movie's details" do
    ally = User.create!(name: 'Ally Jean', email: 'allyjean@example.com')
    movie = MoviesFacade.new.find_movie(234)
    visit user_movie_path(ally, movie.id)

    expect(page).to have_content(movie.title)
    expect(page).to have_content("Vote: #{movie.rating}")
    expect(page).to have_content("Runtime: #{movie.format_runtime}")
    expect(page).to have_content("Genre: #{movie.genres}")
    expect(page).to have_content(movie.summary)
    expect(page).to have_content('Cast List')
    movie.cast.each_with_index do |cast_member, index|
      within("#cast-#{index}") do
        expect(page).to have_content(cast_member.name)
        expect(page).to have_content(cast_member.character)
      end
    end
    expect(page).to have_content('2 Reviews')

    movie.reviews.each_with_index do |review, index|
      within("#review-#{index}") do
        expect(page).to have_content("Author: #{review.author}")
        expect(page).to have_content("Rating: #{review.rating}")
        expect(page).to have_content(review.comments)
      end
    end
  end
end
