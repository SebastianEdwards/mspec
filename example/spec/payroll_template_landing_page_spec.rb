hypothesize 'market segment looking for spreadsheet templates can be targeted' do
  let(:keywords) { ['payroll template', 'payroll excel'] }

  test 'market segment is viable' do
    let(:threshold) { 1000 }

    metric 'monthly local searches' do
      keywords.reduce(0) do |monthly_searches, keyword|
        monthly_searches += GoogleKeywordTool.query(keyword).monthly_searches
      end
    end

    analyse 'meet threshold' do
      result['monthly local searches'] >= threshold
    end
  end

  test 'targeted landing page lowers cost per conversion' do
    let(:landing_page_url) { 'http://templates.smartpayroll.co.nz' }

    run_for_at_least 1.week
    run_for_at_least '300 visits' do
      Unbounce.visits(landing_page_url) > 300
    end

    setup 'redirect adwords' do
      keywords.each do |keyword|
        GoogleAdwords.ad_groups(keyword: keyword).change_target(landing_page_url)
      end
    end

    teardown 'restore adwords' do
      # code
    end

    metric 'conversions' do
      Unbounce.conversions(landing_page_url)
    end

    metric 'advertising spend' do
      GoogleAdwords.ad_groups(keyword: keyword).advertising_spend
    end

    metric 'cost per conversion' do
      metric['advertising spend'] / metric['conversions']
    end

    analyse 'improve cost per conversion' do
      metric['cost per conversion'] < GoogleAdwords.overall_cost_per_conversion
    end
  end
end

# Testing whether market segment looking for spreadsheet templates can be targeted.
# Test: market segment is viable.
# Metrics:
# Monthly local searches: is 1200
# Results:
# Does meet threshold. (Monthly local searches was 1200, needed 1000.)

# Test: targeted landing page lowers cost per conversion.
# Test has been running for 6 days, 17 hours.
# Test has not run for 300 visits. (212, need 300)
# Metrics:
# Conversions: is 16
# Advertising spend: is $15.42
# Cost per conversion: is 0.96375
# Conversions: is 16
# Results:
# Does improve cost per conversion. (Cost per conversion was 0.96375, needed to be less than 1.56.)
