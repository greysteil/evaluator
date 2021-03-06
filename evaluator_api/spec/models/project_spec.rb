# == Schema Information
#
# Table name: projects
#
#  id                   :bigint(8)        not null, primary key
#  course_id            :bigint(8)        not null
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  due_date             :datetime         not null
#  start_date           :datetime         not null
#  name                 :text             not null
#  published            :boolean          default(FALSE), not null
#  quiz                 :boolean          default(FALSE), not null
#  reruning_submissions :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe Project, type: :model do
  let(:subject) { FactoryBot.create(:project) }
  it { should belong_to :course }
  it { should have_many :submissions }
  it { should have_many :test_suites }
  it { should validate_presence_of :name }
  it { should validate_presence_of :due_date }
  it { should validate_presence_of :course }
  it { should validate_uniqueness_of(:name).scoped_to(:course_id).case_insensitive}
  describe 'factory' do
    let(:project) { FactoryBot.build(:project) }
    it 'has a valid factory' do
      expect(project).to be_valid
    end
  end

  context 'query by due date' do
    before(:each) { Project.destroy_all }
    it 'should select due only' do
      FactoryBot.create_list(:project, 5)
      FactoryBot.create_list(:project, 3, due_date: 5.days.ago)
      projects = Project.due
      expect(projects.count).to eql 3
    end
    it 'should select non due only' do
      FactoryBot.create_list(:project, 5)
      FactoryBot.create_list(:project, 3, due_date: 5.days.ago)
      projects = Project.not_due
      expect(projects.count).to eql 5
    end
  end
  context 'query by published' do
    before(:each) { Project.destroy_all }
    it 'should select published only' do
      FactoryBot.create_list(:project, 5, published: false)
      FactoryBot.create_list(:project, 3, published: true)
      projects = Project.published
      expect(projects.count).to eql 3
    end
    it 'should select non published only' do
      FactoryBot.create_list(:project, 5, published: false)
      FactoryBot.create_list(:project, 3, published: true)
      projects = Project.not_published
      expect(projects.count).to eql 5
    end
  end
end
