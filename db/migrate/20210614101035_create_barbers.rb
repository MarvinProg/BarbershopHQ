class CreateBarbers < ActiveRecord::Migration[6.1]
  def change
    create_table :barbers do |t|
      t.text :name
      
      t.timestamps  
    end

    Barber.create :name => 'Иван'
    Barber.create :name => 'Наталья'
    Barber.create :name => 'Джек руки-ножницы'

  end
end
