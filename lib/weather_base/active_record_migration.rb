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
        t.float :long, :nullable => false
        t.text :high_temp_f
        t.text :high_temp_c
        t.text :low_temp_f
        t.text :low_temp_c
        t.text :days_above_85f
        t.text :days_below_70f
        t.text :precip_inches
        t.text :precip_cm
        t.text :snowfall_inches
        t.text :snowfall_cm
      end
    end
  end
end
