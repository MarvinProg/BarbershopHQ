class CreateBarbers < ActiveRecord::Migration[6.1]
  def change
    create_table :barbers do |t|
      t.text :name
      
      t.timestamps  
    end

    Barber.create :name => 'Ivan'
    Barber.create :name => 'Nataliy'
    Barber.create :name => 'Jeck'

  end
end
