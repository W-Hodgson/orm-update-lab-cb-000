require_relative "../config/environment.rb"

class Student

  attr_accessor :name, :grade, :id

  def initialize(name, grade, id=nil)
    @name = name
    @grade = grade
    @id = id
  end

  def self.create_table
    DB[:conn].execute("CREATE TABLE IF NOT EXISTS students(id INTEGER AUTO INCREMENT, name TEXT, grade INTEGER)")
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE students")
  end

  def save
    if @id
      self.update
    else
      DB[:conn].execute("INSERT INTO students(name, grade) VALUES (?, ?)", @name, @grade)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    end
  end

  def self.create(name, grade)
    student = self.new(name, grade)
    student.save
    student
  end

  def self.new_from_db(row)
    student = Student.new(row[1], row[2], row[0])
    student
  end

  def self.find_by_name(name)
    DB[:conn].execute("SELECT * FROM students WHERE name = ?", name).map do |row|
      self.new_from_db(row)
    end.first
  end

  def update
    DB[:conn].execute("UPDATE students SET name = ?, grade = ? WHERE id = ?", @name, @grade, @id)
  end

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn]


end
