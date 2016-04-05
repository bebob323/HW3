Given(/^the following movies exist:$/) do |table|
  table.hashes.each do |n|
    Movie.create n
  end
end