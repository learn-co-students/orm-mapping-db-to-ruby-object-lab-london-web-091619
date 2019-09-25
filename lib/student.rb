class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    new_student = self.new
    new_student.id = row[0]
    new_student.name = row[1]
    new_student.grade = row[2]
    new_student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = "SELECT * FROM students"
    students = DB[:conn].execute(sql)
    students.map{|student| new_from_db(student)}
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = "
    SELECT * 
    FROM students
    WHERE students.name = '#{name}'
    "
    row = DB[:conn].execute(sql)[0]
    self.new_from_db(row)
  end

  
  def save
    sql = "
      INSERT INTO students (name, grade) 
      VALUES (?, ?)
    "

    DB[:conn].execute(sql, self.name, self.grade)
  end
  
  def self.create_table
    sql = "
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    "

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
  
  def self.all_students_in_grade_9
    sql = "
    SELECT *
    FROM students
    WHERE students.grade = 9
    "
    DB[:conn].execute(sql)
  end

  def self.students_below_12th_grade
    sql =  "
    SELECT *
    FROM students
    WHERE students.grade < 12
    "
    students = DB[:conn].execute(sql)
    students.map{|student| new_from_db(student)} 
  end

  def self.first_X_students_in_grade_10(student_amount)
    sql = "
    SELECT *
    FROM students
    ORDER BY students.id LIMIT #{student_amount}
    "
    students = DB[:conn].execute(sql)
    students.map{|student| new_from_db(student)} 
  end

  def self.first_student_in_grade_10
    sql = "
    SELECT *
    FROM students
    GROUP BY students.id HAVING grade = 10 LIMIT 1
    "
    students = DB[:conn].execute(sql)
    students.map{|student| new_from_db(student)}[0]
  end

  def self.all_students_in_grade_X(grade)
    sql = "
    SELECT *
    FROM students
    WHERE grade = '#{grade}'
    "
    students = DB[:conn].execute(sql)
    students.map{|student| new_from_db(student)}
  end
end
