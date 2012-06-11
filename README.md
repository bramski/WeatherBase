WeatherBase
===========

The WeatherBase gem is a rails helper gem which creates classes for helping with data as given by WeatherBase (www.weatherbase.com)

There are two main classes to use as rails mixins.

WeatherBase::ActiveRecordSupport
--------------------------------

This class should be mixed into an activerecord, it provides functionality for getting temperatures, rainfall, and snowfall saved into a mysql DB.

WeatherBase::ActiveRecordMigration
----------------------------------

This is a mixin for active record migrations.  Include it in an active record migration and use the populate_table(t) to generate the necessary fields which ActiveRecordSupport requires.
