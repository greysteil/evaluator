# == Schema Information
#
# Table name: student_course_registrations
#
#  id         :bigint(8)        not null, primary key
#  course_id  :bigint(8)        not null
#  student_id :bigint(8)        not null
#  team       :text
#

require 'rails_helper'

RSpec.describe StudentCourseRegistration, type: :model do
  it { should belong_to :course }
  it { should belong_to :student }
  it { should validate_presence_of :course }
  it { should validate_presence_of :student }
  
  describe 'factory' do
    let(:student_course_registration) { FactoryBot.build(:student_course_registration) }
    it 'should be valid' do
      expect(student_course_registration).to be_valid
    end
  end


  describe 'course students' do
    context 'create joins' do
      let(:students) { FactoryBot.create_list(:student, 3) }
      let(:course) { FactoryBot.create(:course) }
      it 'should be accessible from the other side' do
        course.students << students
        course.save!
        linked = students.reduce { |memo, student| memo && student.courses.first.id == course.id }
        expect(linked).to be true
      end
    end
    context 'delete on dependency' do
      let(:course) { FactoryBot.create(:course) }
      let(:students) { FactoryBot.create_list(:student, 2) }
      it 'join records should be deleted' do
        course.students << students
        course.save!
        expect(StudentCourseRegistration.where(course_id: course.id).count).to eql 2
        course.destroy
        expect(StudentCourseRegistration.where(course_id: course.id).count).to eql 0
      end
    end
  end

  describe 'student courses' do
    context 'create joints' do
      let(:student) { FactoryBot.create(:student) }
      let(:courses) { FactoryBot.create_list(:course, 5) }
      it 'should be accessible from the other side' do
        student.courses << courses
        student.save!
        linked = courses.reduce { |memo, course| memo && course.students.first.id == student.id }
        expect(linked).to be true
      end
    end
    context 'delete on dependency' do
      let(:student) { FactoryBot.create(:student) }
      let(:courses) { FactoryBot.create_list(:course, 3) }
      it 'join records should be deleted' do
        student.courses << courses
        student.save!
        expect(StudentCourseRegistration.where(student_id: student.id).count).to eql 3
        student.destroy
        expect(StudentCourseRegistration.where(student_id: student.id).count).to eql 0
      end
    end
  end
end
