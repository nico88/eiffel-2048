note
	description: "eiffel-2048 application root class, for command line version of the application."
	date: "August 26, 2014"
	revision: "0.01"

class
	APP_2048

inherit

	WSF_DEFAULT_RESPONSE_SERVICE
		redefine
			initialize
		end

create
	make_and_launch

feature -- Implementation

	controller: CONTROLLER_2048
			-- It takes care of the control of the 2048 game.
	user: USER_2048
			-- Used for loading and saving games.

	new_user : USER_2048
	        -- New User registered

	option_pantal: INTEGER
	        -- Display Options

	login (username: STRING; password: STRING)
			-- Validate the user datas
			-- Load the user from the file into the user variable, or void if the user doesn't exist
		require
			(create {USER_2048}.make_for_test).is_valid_nickname (username) and password /= Void
		local
			possible_user: USER_2048
		do
			create possible_user.make_with_nickname (username)
			if possible_user.has_unfinished_game then
				possible_user.load_game
				if equal (password, possible_user.password) then
					user := possible_user
				else
					user := Void
				end
			else
				user := Void
			end
		end


feature {NONE} -- Execution

	response (req: WSF_REQUEST): WSF_HTML_PAGE_RESPONSE
			-- Computed response message.
		do

			create Result.make
			if option_pantal = 0 then --Initial Pantal
				if attached req.string_item ("login") as u_login then
					option_pantal := 1
				else
					if attached req.string_item ("register") as u_register then
						option_pantal := 2
					else
						Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css' >" + "[
							<h1>2048_evil</h1>
							<form action="/" method="POST">
								<input style="background-color: #FF9900" type="submit" name="login" value="Login" style=width:100px;height:50px/>
								<input style="background-color: #FF9900" type="submit" name="register" value="Register" style=width:100px;height:50px/>
							</form>
						]" + "</div>")
					end
				end
			end
			if option_pantal = 1 then -- Login Pantal
				if (attached req.string_item ("nickname") as nick) and (attached req.string_item ("password") as pass) then
					create controller.make
					login (nick, pass)
					if user = void then
						Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
							<h1>2048_evil</h1>						
							<form action="/" method="POST">
								<p>Invalid nickname or password!</p>
								<br>
								<br>
								<p>Insert your nickname</p>
								<input type="text" name="nickname"/>
								<p>Insert your password</p>
								<input type="password" name="password"/>
								<br>
								<br>
	 							<input style='background-color: #FF9900' type="submit" value="Login" style=width:100px;height:50px/>
							</form>
						]" + "</div>")
					else
						user.load_game
						controller.make_with_board (user.game)
						option_pantal := 3
					end
				else
					Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
						<h1>2048_evil</h1>
						<form action="/" method="POST">
							<p>Insert your nickname</p>
							<input type="text" name="nickname"/>
							<p>Insert your password</p>
							<input type="password" name="password"/>
							<br>
							<br>
	 						<input style='background-color: #FF9900' type="submit" value="Login" style=width:100px;height:50px/>
						</form>
					]" + "</div>")
				end
			end
			if option_pantal = 2 then -- Register Pantal
				if (attached req.string_item ("name") as name) and (attached req.string_item ("surname") as surname) and (attached req.string_item ("nickname") as nick) and (attached req.string_item ("password") as pass) then
					create controller.make
					create new_user.make_for_test
					if new_user.is_valid_name (name) and new_user.is_valid_name (surname) and new_user.is_valid_name (nick) and new_user.is_valid_password (pass) then --validate the data
						if not new_user.existing_file (nick) then
							create user.make_new_user (name, surname, nick, pass)
							option_pantal := 3
						else
							Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
						        <h1>2048_evil</h1>											
								<form action="/" method="POST">
									<p>Chosen nickname already exists</p>
									<br>
									<br>
									<p>Insert your name</p>
									<input type="text" name="name"/>
									<p>Insert your surname</p>
									<input type="text" name="surname"/>
									<p>Insert your nickname</p>
									<input type="text" name="nickname"/>
									<p>Insert your password</p>
									<input type="password" name="password"/>
									<br>
									<br>
									<input style='background-color: #FF9900' type="submit" name="register" value="Register" style=width:100px;height:50px/>
								</form>
							]" + "</div>")
						end
					else
						Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
							<h1>2048_evil</h1>
							<form action="/" method="POST">
								<p>Incorrect data, please enter valid data!</p>
								<br>
								<br>
								<p>Insert your name</p>
								<input type="text" name="name"/>
								<p>Insert your surname</p>
								<input type="text" name="surname"/>
								<p>Insert your nickname</p>
								<input type="text" name="nickname"/>
								<p>Insert your password</p>
								<input type="password" name="password"/>
								<br>
								<br>
								<input style='background-color: #FF9900' type="submit" name="register" value="Register" style=width:100px;height:50px/>
							</form>
						]" + "</div>")
					end
				else
					Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
						<h1>2048_evil</h1>
						<form action="/" method="POST">
							<p>Insert your name</p>
							<input type="text" name="name"/>
							<p>Insert your surname</p>
							<input type="text" name="surname"/>
							<p>Insert your nickname</p>
							<input type="text" name="nickname"/>
							<p>Insert your password</p>
							<input type="password" name="password"/>
							<br>
							<br>
							<input style='background-color: #FF9900' type="submit" name="register" value="Register" style=width:100px;height:50px/>
						</form>
					]" + "</div>")
				end
			end
			if option_pantal = 3 then --Play 2048 evil Pantal
			    Result.set_title ("2048_evil")
			    Result.set_body (html_board+style_board+cell_color)
			    -- Up
				if attached req.string_item ("up") as l_up then
					if controller.board.is_winning_board then
						option_pantal := 4 --Win Game Pantal
						controller.make
						user.save_game (controller.board)
					end
					if not controller.board.can_move_up and not controller.board.can_move_down and not controller.board.can_move_left and not controller.board.can_move_right then
						option_pantal := 5 --Game Over Pantal
						controller.make
						user.save_game (controller.board)
					end
				  	if controller.board.can_move_up then
				  		controller.up
						Result.set_body (html_board+style_board+cell_color)
				  	end
				end
				-- Down
				if attached req.string_item ("down") as l_down then
					if controller.board.is_winning_board then
						option_pantal := 4 --Win Game Pantal
						controller.make
						user.save_game (controller.board)
					end
					if not controller.board.can_move_up and not controller.board.can_move_down and not controller.board.can_move_left and not controller.board.can_move_right then
						option_pantal := 5 --Game Over Pantal
						controller.make
						user.save_game (controller.board)
					end
				  	if controller.board.can_move_down then
				  		controller.down
						Result.set_body (html_board+style_board+cell_color)
				  	end
				end
				-- Left
				if attached req.string_item ("left") as l_left then
					if controller.board.is_winning_board then
						option_pantal := 4 --Win Game Pantal
						controller.make
						user.save_game (controller.board)
					end
					if not controller.board.can_move_up and not controller.board.can_move_down and not controller.board.can_move_left and not controller.board.can_move_right then
						option_pantal := 5 --Game Over Pantal
						controller.make
						user.save_game (controller.board)
					end
				  	if controller.board.can_move_left then
				  		controller.left
				  		Result.set_body (html_board+style_board+cell_color)
				  	end
				end
				-- Right
				if attached req.string_item ("right") as l_right then
					if controller.board.is_winning_board then
						option_pantal := 4 --Win Game Pantal
						controller.make
						user.save_game (controller.board)
					end
					if not controller.board.can_move_up and not controller.board.can_move_down and not controller.board.can_move_left and not controller.board.can_move_right then
						option_pantal := 5 --Game Over Pantal
						controller.make
						user.save_game (controller.board)
					end
				  	if controller.board.can_move_right then
				  		controller.right
				  		Result.set_body (html_board+style_board+cell_color)
				  	end
				end
				-- Load Game
				if (attached req.string_item ("load_user") as load_user) and (attached req.string_item ("load_pass") as load_pass) and (attached req.string_item ("load_game") as load_game) then
					user.load_game
					create controller.make_with_board (user.game)
				end
				-- Save Game and Quit
				if (attached req.string_item ("save_user") as save_user) and (attached req.string_item ("save_pass") as save_pass) and (attached req.string_item ("save_quit") as save_quit) then
					user.save_game (controller.board)
					option_pantal := 0 --Initial Pantal
					Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
							<h1>2048_evil</h1>
							<form action="/" method="POST">
								<input style="background-color: #FF9900" type="submit" name="login" value="Login" style=width:100px;height:50px/>
								<input style="background-color: #FF9900" type="submit" name="register" value="Register" style=width:100px;height:50px/>
							</form>
							]" + "</div>")
				end
				Result.add_javascript_url ("https://ajax.googleapis.com/ajax/libs/angularjs/1.2.26/angular.min.js")
				Result.add_javascript_content (main)
			end
			if option_pantal = 4 then --Win Game Pantal
				option_pantal := 0 --Initial Pantal
				Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
							<form action="/" method="POST">
								<input style="background-color: #0B0B61" type="submit" name="game_over" value="GAME OVER!!!" style=width:100px;height:50px/>
							</form>
					]" + "</div>")
			end
			if option_pantal = 5 then --Game Over Pantal
				option_pantal := 0 --Initial Pantal
   				Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
							<form action="/" method="POST">
								<input style="background-color: #0B0B61" type="submit" name="win_game" value="WIN GAME!!!" style=width:100px;height:50px/>
							</form>
					]" + "</div>")
			end
		end

feature {NONE} -- Initialization

	initialize
		do
			create {WSF_SERVICE_LAUNCHER_OPTIONS_FROM_INI} service_options.make_from_file ("ewf.ini")
			create controller.make
			create user.make_new_user("guest","guest","guest","guest") -- Empty user
				--| You can also uncomment the following line if you use the Nino connector
				--| so that the server listens on port 9999
				--| quite often the port 80 is already busy
			Precursor
		end

feature {NONE} --Show board with html table

	main : STRING
		local
			js : STRING
			i,j : INTEGER
		do
			js := ""
			js.append ("var app = angular.module('main',[]). ")
			js.append("controller('BoardController',function($scope,$http) {")
			js.append(" $scope.board = [")
			from
				i := 1
			until
				i > 4
			loop
				js.append (" { ")
				from
					j:=1
				until
					j > 4
				loop
					js.append ("cell"+j.out+":'"+controller.board.elements.item (i, j).value.out+"'")
					if ( j < 4) then
						js.append (",")
					end
					j := j + 1
				end --end j
				js.append (" }")
				if (i < 4) then
					js.append (",")
				end
				i := i + 1
			end --end i
			js.append(" ]; ")
			-- Function color cell
			js.append ("$scope.CellColor=function(cellNumber) { ")
			js.append ("if (cellNumber==0) { return {number0:true};} ")
			js.append ("if (cellNumber==2) { return {number2:true};} ")
			js.append ("if (cellNumber==4) { return {number4:true};} ")
			js.append ("if (cellNumber==8) { return {number8:true};} ")
			js.append ("if (cellNumber==16) { return {number16:true};} ")
			js.append ("if (cellNumber==32) { return {number32:true};} ")
			js.append ("if (cellNumber==64) { return {number64:true};} ")
			js.append ("if (cellNumber==128) { return {number128:true};} ")
			js.append ("if (cellNumber==256) { return {number256:true};} ")
			js.append ("if (cellNumber==512) { return {number512:true};} ")
			js.append ("if (cellNumber==1024) { return {number1024:true};} ")
			js.append ("if (cellNumber==2048) { return {number2048:true};} ")
			js.append ("}; ")
			js.append("})")
			Result := js
		end

	html_board : STRING
		local
			js : STRING
		do
			js := "</body><body ng-app="+"main"+" ng-controller="+"BoardController"+" ng-keydown='KeyControl($event)'>"
			js.append ("<h1>2048_evil</h1>")
			js.append ("<div class='wrapper'>")
			js.append ("<table width="+"300"+" height="+"300"+">")
			js.append ("<tr ng-repeat='row in board'>")
			js.append ("<td ng-class='CellColor({{row.cell1}})'>{{row.cell1}}</td>")
			js.append ("<td ng-class='CellColor({{row.cell2}})'>{{row.cell2}}</td>")
			js.append ("<td ng-class='CellColor({{row.cell3}})'>{{row.cell3}}</td>")
			js.append ("<td ng-class='CellColor({{row.cell4}})'>{{row.cell4}}</td>")
			js.append ("</tr>")
			js.append ("</table>")
			js.append ("<center>")
			-- Up
			js.append ("<form  action="+"/"+" method="+"POST"+">")
			js.append ("<input type='submit' value='Up' name="+"up"+" style=width:100px;height:40px;background-color:#FF9900 >")
			-- Down
			js.append ("<input type='submit' value='Down' name="+"down"+" style=width:100px;height:40px;background-color:#FF9900 >")
			-- Left
			js.append ("<input type='submit' value='Left' name="+"left"+" style=width:100px;height:40px;background-color:#FF9900 >")
			-- Right
			js.append ("<input type='submit' value='Right' name="+"right"+" style=width:100px;height:40px;background-color:#FF9900 >")
			js.append ("</form>")
			js.append ("</center>")
			-- Load Game
			js.append ("<br>")
			js.append ("<center>")
			js.append ("<form action="+"/"+" method="+"POST"+">")
			js.append ("<input type="+"text"+" name="+"load_user"+" style="+"visibility:hidden"+" >")
			js.append ("<input type="+"password"+" name="+"load_pass"+" style="+"visibility:hidden"+" >")
			js.append ("<input type='submit' value='Load Game' name="+"load_game"+" style=width:100px;height:40px;background-color:#088A08 >")
			-- Save and Quit
			js.append ("<input type="+"text"+" name="+"save_user"+" style="+"visibility:hidden"+" >")
			js.append ("<input type="+"password"+" name="+"save_pass"+" style="+"visibility:hidden"+" >")
			js.append ("<input type='submit' value='Save and Quit' name="+"save_quit"+" style=width:100px;height:40px;background-color:#088A08 >")
			js.append ("</form>")
			js.append ("</center>")
			js.append ("</div>")
			Result := js
		end

	style_board : STRING
		local
			js : STRING
		do
			js := "<style>"
			js.append ("h1 {text-align: center;color:#2A0A12;text-shadow:0px 2px 0px #fff;}")
			js.append (".wrapper{width: 500px;margin: 0 auto;box-shadow: 5px 5px 5px #555;border-radius: 15px;padding: 10px;}")
			js.append ("body {background: #58ACFA;font-family: "+"Open Sans"+", arial;}")
			js.append ("table {max-width: 300px;height: 300px;border-collapse: collapse;border: 3px solid white;margin: 50px auto; background-color:white;table-layout: fixed;}")
			js.append ("td {border-right: 3px solid white;padding: 10px;text-align: center;transition: all 0.2s;}")
			js.append ("tr {border-bottom: 3px solid white;}")
			js.append ("tr:last-child {border-bottom: 1px;}")
			js.append ("td:last-child {border-right: 1px; }")
			js.append ("</style>")
			Result := js
		end

	cell_color : STRING
		local
			js : STRING
		do
			js := "<style>"
			js.append (".number0 { background-color:#F7BE81}")
			js.append (".number2 { background-color:#FA5858}")
			js.append (".number4 { background-color:#FE642E}")
			js.append (".number8{ background-color:#FE2E2E}")
			js.append (".number16 { background-color:#FF4000}")
			js.append (".number32 { background-color:#FF0000}")
			js.append (".number64 { background-color:#DF3A01}")
			js.append (".number128 { background-color:#DF0101}")
			js.append (".number256{ background-color:#B43104}")
			js.append (".number512 { background-color:#B40404}")
			js.append (".number1024{ background-color:#8A2908}")
			js.append (".number2048 { background-color:#8A0808}")
			js.append ("</style>")
			Result := js
		end
end
