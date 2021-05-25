module vending_machine (clk, reset, select_product_a,select_product_b, select_product_c, select_product_d, select_product_e, 
								quarter, fifty, dollar, confirm, 
								dispense_product, change, 
								LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5); 
								
  input clk, reset; // clock and reset
  input select_product_a, select_product_b, select_product_c, select_product_d, select_product_e; // 5 available products
  input quarter, fifty, dollar; // three amount selections
  input confirm; // "Confirm" button 
  
  output reg dispense_product;
  output reg [7:0] change;
  
  // 7-Segment display
  output reg [7:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
  
  // 10 LEDs
  output wire [9:0] LEDR; // wire type is needed for compilation
  
  // current and next state registers for sequential block
  reg [2:0] current_state;
  reg [2:0] next_state;
  
  reg [2:0] selected_product_code; 
  
  wire [7:0] total_money_inserted;
  reg [7:0] selected_product_price;
  
	
  reg item_is_available;
  reg insufficient_amount;
  
  // counters to calculate the total_money_inserted
	reg [2:0] quarter_count;
	reg [2:0] fifty_count;
	reg [2:0] dollar_count;
  
   wire [2:0] total_money_inserted_code;
  
  /*
  Seven states:
  1. Wait for product selection from user
  2. Product selection and price assignment  
  3. Check product availability
  4. Insert money 
  5. Check if inserted amount is sufficient 
  6. Dispense product
  7. Return change 
  */
  
  parameter s0 = 3'b000, 
				s1 = 3'b001, 
				s2 = 3'b010, 
				s3 = 3'b011, 
				s4 = 3'b100, 
				s5 = 3'b101, 
				s6 = 3'b110; 

  
  // product prices in cents
  parameter product_a_price = 8'd25,
				product_b_price = 8'd50,
				product_c_price = 8'd75,
				product_d_price = 8'd100,
				product_e_price = 8'd125;
  
  // maximum amount that can be inserted 
  parameter max_amount_of_money = 8'd200;
  
  
  
  // availablity of each product
  parameter product_a_availability = 100,
				product_b_availability = 100,
				product_c_availability = 0,   // Product C is not available for testing purposes 
				product_d_availability = 100,
				product_e_availability = 100;
  
  
  // Test LED, buttons, and switch functionality 
  // assign LEDR [0] = ~(reset) | ~(confirm);
  //assign LEDR [1] = select_product_a | select_product_b;

	
	// indicate that a reset or confirm buttons have been pressed 
	assign LEDR [0] = ~ reset | ~ confirm; 
	
	// change and output LED indicators
	assign LEDR [1] = (dispense_product == 1) ? 1'b1 : 1'b0;
	assign LEDR [2] = (change) ? 1'b1 : 1'b0;
	
		
	assign total_money_inserted = (25 * quarter_count) + (50 * fifty_count) + (100 * dollar_count);
	

	// product selection LED indication
	assign LEDR [9] = (select_product_a) ? 1'b1 : 1'b0;
	assign LEDR [8] = (select_product_b) ? 1'b1 : 1'b0;
	assign LEDR [7] = (select_product_c) ? 1'b1 : 1'b0;
	assign LEDR [6] = (select_product_d) ? 1'b1 : 1'b0;
	assign LEDR [5] = (select_product_e) ? 1'b1 : 1'b0;	
	
	
	// clock division from 50 MHz to 1 Hz
	reg [24:0] counter;
	reg clk_1hz;
	initial begin 
		counter = 0;
		clk_1hz = 0;
	end 
	
	always @(posedge clk)
	begin 
		
		if (counter == 0) 
			begin 
				counter <= 25_000_000;
				clk_1hz <= ~clk_1hz;
			end 
		else
			begin 
				counter <= counter - 1;
			end 
	end 
	
	
	always @ (*)
		begin
			if (current_state == 3'b000) begin
					
					HEX5 = 8'h89; // H
					HEX4 = 8'h86; // E
					HEX3 = 8'hC7; // L
					HEX2 = 8'hC7; // L
					HEX1 = 8'hC0; // O
					HEX0 = 8'hFF; // OFF
				end 
				
			else if (current_state == 3'b001) begin
				
					if (select_product_a == 1) begin 
							// 25 cents
							HEX5 = 8'hA4;
							HEX4 = 8'h92;
							HEX3 = 8'hFF;
							HEX2 = 8'hFF;
							HEX1 = 8'hFF;
							HEX0 = 8'hFF;
						end 
					else if (select_product_b == 1) begin 
							// 50 cents
							HEX5 = 8'h92;
							HEX4 = 8'hC0;
							HEX3 = 8'hFF;
							HEX2 = 8'hFF;
							HEX1 = 8'hFF;
							HEX0 = 8'hFF;
						end 
					else if (select_product_c == 1) begin 
							// 75 cents
							HEX5 = 8'hF8;
							HEX4 = 8'h92;
							HEX3 = 8'hFF;
							HEX2 = 8'hFF;
							HEX1 = 8'hFF;
							HEX0 = 8'hFF;
						end 
					else if (select_product_d == 1) begin 
							// 100 cents
							HEX5 = 8'hF9;
							HEX4 = 8'hC0;
							HEX3 = 8'hC0;
							HEX2 = 8'hFF;
							HEX1 = 8'hFF;
							HEX0 = 8'hFF;
						end
					else if (select_product_e == 1) begin
							// 125 cents
							HEX5 = 8'hF9;
							HEX4 = 8'hA4;
							HEX3 = 8'h92;
							HEX2 = 8'hFF;
							HEX1 = 8'hFF;
							HEX0 = 8'hFF;
						end 
					
					end
				
			else if (current_state == 3'b010) begin 
					if (item_is_available == 1'b1)
						begin
							// yes
							HEX5 = 8'h91;
							HEX4 = 8'h86;
							HEX3 = 8'h92;
							HEX2 = 8'hFF;
							HEX1 = 8'hFF;
							HEX0 = 8'hFF;
						end 
					else begin
							// Error
							HEX5 = 8'h86;
							HEX4 = 8'hCE;
							HEX3 = 8'hCE;
							HEX2 = 8'hC0;
							HEX1 = 8'hCE;
							HEX0 = 8'hFF;
					end
			end 
			
		   else if (current_state == 3'b011) begin
				 if (total_money_inserted == 0) begin
						HEX5 = 8'hC0;
						HEX4 = 8'hC0;
						HEX3 = 8'hC0;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				 
				 end
				 if (total_money_inserted == 25) begin
						// 25
						HEX5 = 8'hA4;
						HEX4 = 8'h92;
						HEX3 = 8'hFF;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
					end 
				else if (total_money_inserted == 50) begin 
						// 50 cents
						HEX5 = 8'h92;
						HEX4 = 8'hC0;
						HEX3 = 8'hFF;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
					end 
				else if (total_money_inserted == 75) begin
						// 75 cents
						HEX5 = 8'hF8;
						HEX4 = 8'h92;
						HEX3 = 8'hFF;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				
				end 
				 
				else if (total_money_inserted == 100) begin 
						// 100 cents
						HEX5 = 8'hF9;
						HEX4 = 8'hC0;
						HEX3 = 8'hC0;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end 
				else if (total_money_inserted == 125) begin 
						// 125 cents
						HEX5 = 8'hF9;
						HEX4 = 8'hA4;
						HEX3 = 8'h92;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end 
				else if (total_money_inserted == 150) begin
						// 150 cents
						HEX5 = 8'hF9;
						HEX4 = 8'h92;
						HEX3 = 8'hC0;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end
				else if (total_money_inserted == 175) begin
						// 175 cents
						HEX5 = 8'hF9;
						HEX4 = 8'hF8;
						HEX3 = 8'h92;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end
				else if (total_money_inserted == 200) begin
						// 200 cents
						HEX5 = 8'hA4;
						HEX4 = 8'hC0;
						HEX3 = 8'hC0;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end
					
			end
			
			else if (current_state == 3'b100) begin
				if (insufficient_amount == 1) begin
					// Error
					HEX5 = 8'h86;
					HEX4 = 8'hCE;
					HEX3 = 8'hCE;
					HEX2 = 8'hC0;
					HEX1 = 8'hCE;
					HEX0 = 8'hFF;
				end
			end
			
			
			else if (current_state == 3'b101) begin
				if (dispense_product == 1) begin
						HEX5 = 8'hC0;
						HEX4 = 8'hC1;
						HEX3 = 8'h87;
						HEX2 = 8'hB7;
						HEX1 = 8'hF9;
						HEX0 = 8'hFF;
						end
				
				end 
				
		   else if (current_state == 3'b110) begin
				 if (change == 0) begin
						HEX5 = 8'hC0;
						HEX4 = 8'hC0;
						HEX3 = 8'hC0;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				 
				 end
				 if (change == 25) begin
						// 25
						HEX5 = 8'hA4;
						HEX4 = 8'h92;
						HEX3 = 8'hFF;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
					end 
				else if (change == 50) begin 
						// 50 cents
						HEX5 = 8'h92;
						HEX4 = 8'hC0;
						HEX3 = 8'hFF;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
					end 
				else if (change == 75) begin
						// 75 cents
						HEX5 = 8'hF8;
						HEX4 = 8'h92;
						HEX3 = 8'hFF;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				
				end 
				 
				else if (change == 100) begin 
						// 100 cents
						HEX5 = 8'hF9;
						HEX4 = 8'hC0;
						HEX3 = 8'hC0;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end 
				else if (change == 125) begin 
						// 125 cents
						HEX5 = 8'hF9;
						HEX4 = 8'hA4;
						HEX3 = 8'h92;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end 
				else if (change == 150) begin
						// 150 cents
						HEX5 = 8'hF9;
						HEX4 = 8'h92;
						HEX3 = 8'hC0;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end
				else if (change == 175) begin
						// 175 cents
						HEX5 = 8'hF9;
						HEX4 = 8'hF8;
						HEX3 = 8'h92;
						HEX2 = 8'hFF;
						HEX1 = 8'hFF;
						HEX0 = 8'hFF;
				end
				
			
			end
					
		
		end
				
	
	// handle inserted money
	always @ (posedge clk_1hz) begin
		if (~reset)
			begin
			quarter_count <= 0;
			fifty_count <= 0;
			dollar_count <= 0;
			end
		else 
			if (quarter) quarter_count <= quarter_count + 1;
			else if (fifty) fifty_count <= fifty_count + 1;
			else if (dollar) dollar_count <= dollar_count + 1;
		end
		
		
  // sequential block
  always @ (posedge clk_1hz)
    begin
      if (~reset)
        begin 
          current_state <= s0;
        end 
      else
        begin
          current_state <= next_state;
        end 
    end 
  
  
  // combinational block
   always @ (*)
    begin
      case(current_state)
        
        s0:
          begin 
				dispense_product = 0;
				change = 0;
            if (select_product_a | select_product_b | select_product_c | select_product_d | select_product_e)
					begin 
						// product has been selected
						next_state = s1;
					end
				else
				begin
					// selection has not been made yet	
					next_state = s0; 
				end
          end
        
        s1:
          begin
				dispense_product = 0;
				change = 0;			 
				
				if (~confirm) begin
					// user has to confirm in order to move to s2  
					next_state = s2;
					end 
			
			
				// price assignment per product
            if (select_product_a == 1) begin
					selected_product_price =  product_a_price;
					selected_product_code = 3'b000;
					end
				else if (select_product_b == 1) begin
					selected_product_price =  product_b_price;
					selected_product_code = 3'b001;
					end
				else if (select_product_c == 1) begin
					selected_product_price =  product_c_price;
					selected_product_code = 3'b010;
					end
				else if (select_product_d == 1) begin
					selected_product_price =  product_d_price;
					selected_product_code = 3'b011;
				end		
				else if (select_product_e == 1) begin
					selected_product_price =  product_e_price;  
					selected_product_code = 3'b100;
				end
				else next_state = s1;
			
          end 
      
        s2:
          begin
				dispense_product = 0;
				change = 0;
				
				if (~confirm & item_is_available == 1'b1) begin
					// item must be available and the user has to confirm in order to transition to s3
					next_state = s3;
				end
				
				if (selected_product_code == 3'b000) begin
					selected_product_price =  product_a_price;
					if (product_a_availability > 0) begin
						//next_state = s3;
						item_is_available = 1'b1;
						end
					else begin
						next_state = s0;
						item_is_available = 1'b0;
					end	
				end 
				
				else if (selected_product_code == 3'b001) begin
					selected_product_price =  product_b_price;
					if (product_b_availability > 0) begin
						//next_state = s3;
						item_is_available = 1'b1;
						end
					else begin
						next_state = s0;
						item_is_available = 1'b0;
					end	
					
				end
				else if (selected_product_code == 3'b010) begin
					selected_product_price =  product_c_price;
					if (product_c_availability > 0) begin
						//next_state = s3;
						item_is_available = 1'b1;
						end
					else begin
						next_state = s0;
						item_is_available = 1'b0;
					end	
				end
				else if (selected_product_code == 3'b011) begin
					selected_product_price =  product_d_price;
					if (product_d_availability > 0) begin
						//next_state = s3;
						item_is_available = 1'b1;
						end
					else begin
						next_state = s0;
						item_is_available = 1'b0;
					end	
				end
				else if (select_product_e == 3'b100) begin
					selected_product_price =  product_e_price; 
					if (product_e_availability > 0) begin
						//next_state = s3;
						item_is_available = 1'b1;
						end
					else begin
						next_state = s0;
						item_is_available = 1'b0;
					end	
				end
			
			
          end 
        
        s3:
          begin
				 dispense_product = 0;
				 change = 0;  
				 next_state = s3;
				 
				 if (total_money_inserted >= max_amount_of_money) begin
					next_state = s4;
				 end
				 else if (~confirm) begin
						next_state = s4;
					end
          end 
         
        s4:
          begin 
            if (total_money_inserted >= selected_product_price)
              begin 
                $display("Inserted amount is sufficient!");
                next_state = s5;
					 insufficient_amount = 0;
              end 
				 else begin
					insufficient_amount = 1;
					next_state = s6; // transition to S6 in order to return inserted money as change
				 end
          end 
        
        s5:
          begin 
            $display("Debug: State 6");
				dispense_product = 1;
				change = 0;
				if (~confirm) begin
					// user has to confirm receiving the dispensed item in order to transition to s6
					next_state = s6;
					end 
				else next_state = s5;
			end 
        
        s6:
          begin 
            $display("Debug: State 7");
				
				// state transition logic
            if (~confirm) begin
						// user has to confirm receiving change in order to transition to s0
						next_state = s0;
					end 
				else next_state = s6;
				
				// change logic
				if (total_money_inserted == selected_product_price) begin
					change = 0;
					dispense_product = 1;
					end 
				else if (total_money_inserted > selected_product_price) begin
					change = total_money_inserted - selected_product_price;
					dispense_product = 1;
					end
				else begin 
					change = total_money_inserted; // return inserted money as change
					dispense_product = 0;
					end
				
				$display ("Change: %d", change);
          end
			 
      endcase 
 
    end 
	 
	 
endmodule 



