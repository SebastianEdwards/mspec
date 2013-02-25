hypothesize 'new keywords are viable' do
  let(:keywords) { IO.readlines('data/keywords') }

  keywords.each do |keyword|
    test "'#{keyword}' is viable" do
      let(:threshold) { 400 }

      metric 'monthly local searches' do
        GoogleKeywordTool.query(keyword).monthly_searches
      end

      analyse 'meet threshold' do
        result['monthly local searches'] >= threshold
      end
    end
  end
end

# Testing whether new keywords are viable.
# Test: 'burgers' is viable
# Metrics:
# Monthly local searches: is 550
# Results:
# Does meet threshold. (Monthly local searches was 550, needed 400.)

# Test: 'pizza' is viable
# Metrics:
# Monthly local searches: is 300
# Results:
# Does not meet threshold. (Monthly local searches was 300, needed 400.)
