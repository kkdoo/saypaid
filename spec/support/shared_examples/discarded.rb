RSpec.shared_examples "have column #discarded_at" do
  describe "#discarded_at" do
    it { should have_db_column(:discarded_at).of_type(:datetime) }
    it { should have_db_index(:discarded_at) }
  end
end
