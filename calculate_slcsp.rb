require 'csv'

# Function to calculate the second lowest cost silver plan for a given rate area
def calculate_second_lowest_cost_silver_plan(plans)
  # Sort the plans by rate in ascending order
  sorted_plans = plans.sort_by { |plan| plan['rate'] }

  # Initialize variables to keep track of the first and second lowest rates
  first_lowest_rate = nil
  second_lowest_rate = nil

  # Iterate through the sorted plans to find the second lowest rate
  sorted_plans.each do |plan|
    if first_lowest_rate.nil?
      # If first_lowest_rate is not set, set it to the rate of the first plan
      first_lowest_rate = plan['rate']
    elsif plan['rate'] != first_lowest_rate
      # If the rate is different from the first lowest rate, set it as the second lowest rate
      second_lowest_rate = plan['rate']
      break
    end
  end

  second_lowest_rate
end

# Read the plans.csv file and create a dictionary of plans by rate area
plans_by_rate_area = Hash.new { |hash, key| hash[key] = [] }
CSV.foreach('plans.csv', headers: true) do |row|
  rate_area = [row['state'], row['rate_area']]
  plan = {
    'rate' => row['rate'].to_f,
    'metal_level' => row['metal_level']
  }
  plans_by_rate_area[rate_area] << plan
end

# Read the slcsp.csv file and determine the SLCSP for each ZIP code
CSV.open('output.csv', 'w') do |output_file|
  output_file << ['zipcode', 'rate']

  CSV.foreach('slcsp.csv', headers: true) do |row|
    zip_code = row['zipcode']
    rate_area_candidates = Set.new

    # Find the rate areas associated with the ZIP code in zips.csv
    CSV.foreach('zips.csv', headers: true) do |zip_row|
      if zip_row['zipcode'] == zip_code
        rate_area_candidates.add([zip_row['state'], zip_row['rate_area']])
      end
    end

    # If there's only one rate area candidate, calculate SLCSP for that rate area
    if rate_area_candidates.size == 1
      rate_area = rate_area_candidates.to_a[0]
      slcsp = calculate_second_lowest_cost_silver_plan(plans_by_rate_area[rate_area])
      row['rate'] = slcsp&.round(2)
    end

    output_file << [row['zipcode'], row['rate']]
  end
end
