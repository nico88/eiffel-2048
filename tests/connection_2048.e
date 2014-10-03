note
	description: "Summary description for {CONNECTION_2048}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	CONNECTION_2048

create
	make

feature -- Access

	repository: PS_REPOSITORY

	generated_id: INTEGER

	user: USER_2048

		-- The ID generated by the database.

feature {NONE} -- Initialization

	make
			-- Set up the repository.
		local
			factory: PS_MYSQL_RELATIONAL_REPOSITORY_FACTORY
		do
			create factory.make
			factory.set_database ("my_database")
			factory.set_user ("root")
			factory.set_password ("1234")

				-- Tell ABEL to manage the `USER_2048' type.
			factory.manage ({USER_2048}, "id")

			repository := factory.new_repository

			--insert_user
			--update_user
		end

end
