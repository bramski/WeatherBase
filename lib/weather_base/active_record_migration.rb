module WeatherBase
  module ActiveRecordMigration
    
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def populate_table(t)
        t.integer :id
        t.integer :weatherbase_id, :unique => true, :nullable => false
        t.string :city
        t.string :state
        t.string :country
        t.float :lat, :nullable => false
        t.float :lng, :nullable => false
        t.string :high_temp_f
        t.string :high_temp_c
        t.string :low_temp_f
        t.string :low_temp_c
        t.string :days_above_85f
        t.string :days_below_70f
        t.string :precip_inches
        t.string :precip_cm
        t.string :snowfall_inches
        t.string :snowfall_cm
      end
    end
  end
end
