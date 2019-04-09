before do
    @menu = SQLite3::Database.new 'menu.sqlite'
end

get '/shef_menu' do
    @shef_results = @menu.execute 'SELECT * FROM shef_menu'  
    erb :page_shef_menu    
end

post '/shef_add' do
    @submitted_add = true
    
    #sanitisation
    @name = params[:name].strip
    @price = params[:price].strip
    @category = params[:category].strip
    @description = params[:description].strip
    @id = params[:id].strip
    @stock = params[:stock].strip
    
    #validation checks
    @name_valid = !@name.nil? && @name != ""      
    
        
        
    count = @menu.get_first_value(
        'SELECT COUNT(*) FROM shef_menu WHERE name = ?',
        [@name])
    @unique = (count == 0)
    
    @price_valid = @price =~ /^-?[0-9]\d*(.\d+)/

    @id_is_integer = @id =~ /^[0-9]*$/
    @stock_is_integer = @stock =~ /^[0-9]*$/
    
    if @id_is_integer
            id = @id
    end
        
    if @id == ""
        id = @menu.get_first_value('SELECT MAX(id)+1 FROM shef_menu');
    end
        
    if @stock_is_integer
        stock = @stock
    end
        
    if @stock == ""
        stock = 50;
    end       
    
    
    
    #adding item to the database
    if @name_valid && @unique && @price_valid
        
        

        
        @menu.execute(
            
            'INSERT INTO shef_menu VALUES (?, ?, ?, ?, ?, ?)',
            [id, @name, @category, @price, @description, stock])
        
          redirect '/menu'
        end
    
    erb :page_shef_menu
  
end


post '/shef_remove' do
    @submitted_remove = true
    
    #sanitisation
    @id = params[:id].strip
    
    #validation checks
    @id_not_empty = !@id.nil? && @id != "" 
    @id_is_integer = @id =~ /^[0-9]*$/
        
    count = @menu.get_first_value(
        'SELECT COUNT(*) FROM shef_menu WHERE id = ?',
        [@id])
    @id_exists = (count == 1)
    
    @id_valid = @id_not_empty && @id_is_integer && @id_exists        
    
    
    #removing item from the database
    if @id_valid
        
        @menu.execute(        
            'DELETE FROM shef_menu WHERE id = (?)',
            [@id])
        
            redirect '/menu'
    end
    
    erb :page_shef_menu

end


