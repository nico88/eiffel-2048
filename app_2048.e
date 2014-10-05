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

	pantal: INTEGER

	login (username: STRING; password: STRING)
			-- validate the user datas
			-- load the user from the file into the user variable, or void if the user doesn't exist
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
			if pantal = 0 then --Initial
				if attached req.string_item ("login") as l_user then
					pantal := 1
				else
					if attached req.string_item ("register") as l_user then
						pantal := 2
					else
						--| Otherwise, ask for name
						Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
							<h1>2048_evil</h1>
							<form action="/" method="POST">
							<input type="submit" name="login" value="Login" style=width:100px;height:50px/>
							<input type="submit" name="register" value="Register" style=width:100px;height:50px/>
							</form>
						]" + "</div>")
					end
				end
			end
			if pantal = 1 then -- Login
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
								<input type="text" name="password"/>
								<br>
	 							<input type="submit" value="Login" style=width:100px;height:50px/>
							</form>
						]" + "</div>")
					else
						user.load_game
						controller.make_with_board (user.game)
						pantal := 3
					end
				else
					Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
						<h1>2048_evil</h1>						
						<form action="/" method="POST">
							<p>Insert your nickname</p>
							<input type="text" name="nickname"/>
							<p>Insert your password</p>
							<input type="text" name="password"/>
							<br>
	 						<input type="submit" value="Login" style=width:100px;height:50px/>
						</form>
					]" + "</div>")
				end
			end
			if pantal = 2 then -- Register
				if (attached req.string_item ("name") as name) and (attached req.string_item ("surname") as surname) and (attached req.string_item ("nickname") as nick) and (attached req.string_item ("password") as pass) then
					create controller.make
					create new_user.make_for_test
					if new_user.is_valid_name (name) and new_user.is_valid_name (surname) and new_user.is_valid_name (nick) and new_user.is_valid_password (pass) then --validate the data
						if not new_user.existing_file (nick) then
							create user.make_new_user (name, surname, nick, pass)
							pantal := 3
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
									<input type="text" name="password"/>
									<br>
									<input type="submit" name="register" value="Register" style=width:100px;height:50px/>
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
								<input type="text" name="password"/>
								<br>
								<input type="submit" name="register" value="Register" style=width:100px;height:50px/>
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
							<input type="text" name="password"/>
							<br>
							<input type="submit" name="register" value="Register" style=width:100px;height:50px/>
						</form>
					]" + "</div>")
				end
			end
			if pantal = 3 then --Play 2048 evil
			    Result.set_title ("2048_evil")
			    -- Up
				if attached req.string_item ("up") as l_up then
				  	if controller.board.can_move_up then
				  		controller.up
				  	end
					Result.set_body (html_board+style_board+cell_color_board)
				end
				-- Down
				if attached req.string_item ("down") as l_down then
				  	if controller.board.can_move_down then
				  		controller.down
				  	end
					Result.set_body (html_board+style_board+cell_color_board)
				end
				-- Left
				if attached req.string_item ("left") as l_left then
				  	if controller.board.can_move_left then
				  		controller.left
				  	end
					Result.set_body (html_board+style_board+cell_color_board)
				end
				-- Right
				if attached req.string_item ("right") as l_right then
				  	if controller.board.can_move_right then
				  		controller.right
				  	end
					Result.set_body (html_board+style_board+cell_color_board)
				end
				-- Load Game
				if (attached req.string_item ("load_user") as load_user) and (attached req.string_item ("load_pass") as load_pass) then
					user.load_game
					create controller.make_with_board (user.game)
				end
				-- Save Game and Quit
				if (attached req.string_item ("save_user") as save_user) and (attached req.string_item ("save_pass") as save_pass)then
					user.set_nickname (save_user)
					user.set_pass (save_pass)
					user.save_game(controller.board)
					Result.set_body ("<div align='center' ><link rel='stylesheet' type='text/css' href='https://d6945afcf8ed7ae0f49064a6a2455cbc47151266.googledrive.com/host/0B-xNCeUqs--aLW9HRTZiNWpDdUU/main.css'>" + "[
							<h1>2048_evil</h1>
							<form action="/" method="POST">
								<input type="submit" name="login" value="Login" style=width:100px;height:50px/>
								<input type="submit" name="register" value="Register" style=width:100px;height:50px/>
							</form>
							]" + "</div>")
				end
			    Result.set_body (html_board+style_board+cell_color_board)
				Result.add_javascript_url ("https://ajax.googleapis.com/ajax/libs/angularjs/1.2.26/angular.min.js")
				Result.add_javascript_content (main_script)
			end
			if pantal = 4 then --Game Over
				Result.set_body (html_game_over)
			end
			if pantal = 5 then --Win Game
				Result.set_body (html_win_game)
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

	main_script : STRING
		local
			s : STRING
			i,j : INTEGER
		do
			s := ""
			s.append ("var app = angular.module('main',[]). ")
			s.append("controller('BoardController',function($scope,$http) {")
			s.append(" $scope.board = [")
			from
				i := 1
			until
				i > 4
			loop
				s.append (" { ")
				from
					j:=1
				until
					j > 4
				loop
				s.append ("cell"+j.out+":'"+controller.board.elements.item (i, j).value.out+"'")
				if ( j < 4) then
					s.append (",")
				end
				j := j + 1
				end
				s.append (" }")
				if (i < 4) then
					s.append (",")
				end
				i := i + 1
			end
			s.append(" ]; ")
			-- Cell color function
			s.append ("$scope.CellColor=function(cellNumber) { ")
			s.append ("if (cellNumber==0) { return {number0:true};} ")
			s.append ("if (cellNumber==2) { return {number2:true};} ")
			s.append ("if (cellNumber==4) { return {number4:true};} ")
			s.append ("if (cellNumber==8) { return {number8:true};} ")
			s.append ("if (cellNumber==16) { return {number16:true};} ")
			s.append ("if (cellNumber==32) { return {number32:true};} ")
			s.append ("if (cellNumber==64) { return {number64:true};} ")
			s.append ("if (cellNumber==128) { return {number128:true};} ")
			s.append ("if (cellNumber==256) { return {number256:true};} ")
			s.append ("if (cellNumber==512) { return {number512:true};} ")
			s.append ("if (cellNumber==1024) { return {number1024:true};} ")
			s.append ("if (cellNumber==2048) { return {number2048:true};} ")
			s.append ("}; ")
			-- Key control function
			s.append ("$scope.KeyControl=function(ev){ ")
			s.append ("if (ev.which==37) { $scope.pressed='a';   } ")
			s.append ("if (ev.which==38) { $scope.pressed='w'; } ")
			s.append ("if (ev.which==39) { $scope.pressed='d';} ")
			s.append ("if (ev.which==40) { $scope.pressed='s';}  ")
			s.append ("}; ")
			s.append("})")
			Result := s
		end

	html_board : STRING
		local
			s : STRING
		do
			s:="</body><body ng-app="+"main"+" ng-controller="+"BoardController"+" ng-keydown='KeyControl($event)'>"
			s.append ("<h1>2048_evil</h1>")
			s.append ("<div class='wrapper'>")
			s.append ("<table width="+"300"+" height="+"300"+">")
			s.append ("<tr ng-repeat='row in board'>")
			s.append ("<td ng-class='CellColor({{row.cell1}})'>{{row.cell1}}</td>")
			s.append ("<td ng-class='CellColor({{row.cell2}})'>{{row.cell2}}</td>")
			s.append ("<td ng-class='CellColor({{row.cell3}})'>{{row.cell3}}</td>")
			s.append ("<td ng-class='CellColor({{row.cell4}})'>{{row.cell4}}</td>")
			s.append ("</tr>")
			s.append ("</table>")
			-- Up
			s.append ("<br>")
			s.append ("<form  action="+"/"+" method="+"POST"+">")
			s.append ("<input type='submit' value='Up' name="+"up"+" style=width:100px;height:40px >")
			s.append ("</form>")
			-- Down
			s.append ("<br>")
			s.append ("<form  action="+"/"+" method="+"POST"+">")
			s.append ("<input type='submit' value='Down' name="+"down"+" style=width:100px;height:40px >")
			s.append ("</form>")
			-- Left
			s.append ("<br>")
			s.append ("<form  action="+"/"+" method="+"POST"+">")
			s.append ("<input type='submit' value='Left' name="+"left"+" style=width:100px;height:40px >")
			s.append ("</form>")
			-- Right
			s.append ("<br>")
			s.append ("<form  action="+"/"+" method="+"POST"+">")
			s.append ("<input type='submit' value='Right' name="+"right"+" style=width:100px;height:40px >")
			s.append ("</form>")
			-- Load
			s.append ("<br>")
			s.append ("<form action="+"/"+" method="+"POST"+">")
			s.append ("<input type="+"text"+" name="+"load_user"+" style="+"visibility:hidden"+" >")
			s.append ("<input type="+"password"+" name="+"load_pass"+" style="+"visibility:hidden"+" >")
			s.append ("<input type="+"submit"+" value="+"Load game"+" style="+"width:100px;height:40px"+" >")
			s.append ("</form>")
			-- Save and Quit
			s.append ("<br>")
			s.append ("<form action="+"/"+" method="+"POST"+">")
			s.append ("<input type="+"text"+" name="+"save_user"+" style="+"visibility:hidden"+" >")
			s.append ("<input type="+"password"+" name="+"save_pass"+" style="+"visibility:hidden"+" >")
			s.append ("<input type="+"submit"+" value="+"Save and Quit"+" style="+"width:100px;height:40px"+">")
			s.append ("</form>")
			s.append ("</div>")
			Result := s
		end

	style_board : STRING
		local
			s : STRING
		do
			s:="<style>"
			s.append ("h1 {text-align: center;color:#666;text-shadow:0px 2px 0px #fff;}")
			s.append (".wrapper{width: 650px;margin: 0 auto;box-shadow: 5px 5px 5px #555;border-radius: 15px;padding: 10px;}")
			s.append ("body {background: #58ACFA;font-family: "+"Open Sans"+", arial;}")
			s.append ("table {max-width: 300px;height: 300px;border-collapse: collapse;border: 3px solid white;margin: 50px auto; background-color:white;table-layout: fixed;}")
			s.append ("td {border-right: 3px solid white;padding: 10px;text-align: center;transition: all 0.2s;}")
			s.append ("tr {border-bottom: 3px solid white;}")
			s.append ("tr:last-child {border-bottom: 1px;}")
			s.append ("td:last-child {border-right: 1px; }")
			s.append ("</style>")
			Result := s
		end

	cell_color_board : STRING
		local
			s : STRING
		do
			s := "<style>"
			s.append (".number0 { background-color:#C1BABA}")
			s.append (".number2 { background-color:#eee4da}")
			s.append (".number4 { background-color:#ede0c8}")
			s.append (".number8{ background-color:#f2b179}")
			s.append (".number16 { background-color:#f59563}")
			s.append (".number32 { background-color:#f67c5f}")
			s.append (".number64 { background-color:#f65e3b}")
			s.append (".number128 { background-color:#edcf72}")
			s.append (".number256{ background-color:#edcc61}")
			s.append (".number512 { background-color:#edc850}")
			s.append (".number1024{ background-color:#edc53f}")
			s.append (".number2048 { background-color:#edc22e}")
			s.append ("</style>")
			Result := s
		end

	html_game_over : STRING
		local
			s : STRING
		do
			s:="</body><body ng-app="+"main"+" ng-controller="+"BoardController"+" ng-keydown='KeyControl($event)'>"
			s.append ("<h1>GAME OVER!!!</h1>")
			s.append ("<div class='wrapper'>")
			s.append ("</div>")
		end
	html_win_game : STRING
		local
			s : STRING
		do
			s:="</body><body ng-app="+"main"+" ng-controller="+"BoardController"+" ng-keydown='KeyControl($event)'>"
			s.append ("<h1>WIN GAME!!!</h1>")
			s.append ("<div class='wrapper'>")
			s.append ("</div>")
		end
end
