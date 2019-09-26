class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = Student.new
    row[2] = row[2].to_i
    student.id, student.name, student.grade = row
    student
  end

  def self.all
    sql = <<-SQL
      SELECT * FROM students
    SQL
    result = DB[:conn].execute(sql)
    result.map { |row| new_from_db(row) }
  end

  def self.find_by_name(name)
    sql = <<-SQL
      SELECT * FROM students
      WHERE name = ?
    SQL
    result = DB[:conn].execute(sql, name).first
    new_from_db(result)
  end

  def self.all_students_in_grade_9
    all_students_in_grade_X(9)
  end

  def self.students_below_12th_grade
    all.select { |student| student.grade < 12 }
  end

  def self.first_X_students_in_grade_10(x)
    all.select { |student| student.grade.eql?(10) }.first(x)
  end

  def self.first_student_in_grade_10
    all.find { |student| student.grade.eql?(10) }
  end

  def self.all_students_in_grade_X(x)
    all.select { |student| student.grade.eql?(x) }
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, name, grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
