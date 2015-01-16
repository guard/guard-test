require 'spec_helper'

describe Guard::Test::Runner do

  describe "#initialize" do
    describe "sets the @runner instance variable from options" do
      it "sets default options" do
        runner = described_class.new
        expect(runner.instance_variable_get(:@options)[:bundler]).to be_truthy
        expect(runner.instance_variable_get(:@options)[:rubygems]).to be_falsey
        expect(runner.instance_variable_get(:@options)[:rvm]).to be_empty
        expect(runner.instance_variable_get(:@options)[:drb]).to be_falsey
        expect(runner.instance_variable_get(:@options)[:zeus]).to be_falsey
        expect(runner.instance_variable_get(:@options)[:spring]).to be_falsey
        expect(runner.instance_variable_get(:@options)[:cli]).to eq ""
      end

      describe ":bundler option" do
        context "with the :drb option set to true" do
          it "uses drb but not bundler" do
            runner = described_class.new(drb: true, bundler: true)
            expect(runner).to be_drb
            expect(runner).not_to be_bundler
          end
        end

        context "with the :drb option set to false" do
          it "uses bundler but not drb" do
            runner = described_class.new(drb: false, bundler: true)
            expect(runner).not_to be_drb
            expect(runner).to be_bundler
          end
        end

        context "with the :zeus option set to true" do
          it "uses zeus but not bundler" do
            runner = described_class.new(zeus: true, bundler: true)
            expect(runner).to be_zeus
            expect(runner).not_to be_bundler
          end
        end

        context "with the :zeus option set to false" do
          it "uses bundler but not zeus" do
            runner = described_class.new(zeus: false, bundler: true)
            expect(runner).not_to be_zeus
            expect(runner).to be_bundler
          end
        end

        context "with the :spring option set to true" do
          it "uses spring but not bundler" do
            runner = described_class.new(spring: true, bundler: true)
            expect(runner).to be_spring
            expect(runner).not_to be_bundler
          end
        end

        context "with the :spring option set to false" do
          it "uses bundler but not spring" do
            runner = described_class.new(spring: false, bundler: true)
            expect(runner).not_to be_spring
            expect(runner).to be_bundler
          end
        end
      end

      describe ":rubygems option" do
        context "with the :bundler option set to true" do
          it "uses bundler but not rubygems" do
            runner = described_class.new(bundler: true, rubygems: true)
            expect(runner).to be_bundler
            expect(runner).not_to be_rubygems
          end
        end

        context "with the :bundler option set to false" do
          it "uses rubygems but not bundler" do
            runner = described_class.new(bundler: false, rubygems: true)
            expect(runner).not_to be_bundler
            expect(runner).to be_rubygems
          end
        end
      end

      describe ":rvm option" do
        it "sets the option in the instance @options hash" do
          runner = described_class.new(rvm: '1.9.2')
          expect(runner.instance_variable_get(:@options)[:rvm]).to eq '1.9.2'
        end
      end

      describe ":drb option" do
        it "uses drb" do
          runner = described_class.new(drb: true)
          expect(runner).to be_drb
        end
      end

      describe ":zeus option" do
        it "uses zeus" do
          runner = described_class.new(zeus: true)
          expect(runner).to be_zeus
        end
      end

      describe ":spring option" do
        it "uses spring" do
          runner = described_class.new(spring: true)
          expect(runner).to be_spring
        end
      end

      describe ":cli option" do
        it "sets the option in the instance @options hash" do
          runner = described_class.new(cli: '--show-detail-immediately')
          expect(runner.instance_variable_get(:@options)[:cli]).to eq '--show-detail-immediately'
        end
      end
    end
  end

  describe "#run" do
    let(:guard_test_runner_require) { "-r #{@lib_path.join('guard/test/guard_test_runner')} " }

    context "in empty folder" do
      before(:each) do
        allow(Dir).to receive(:pwd).and_return("empty")
      end

      context "when no :bundler option was given on initialize" do
        subject do
          runner = described_class.new
          runner
        end

        it "runs without bundler" do
          expect(subject).to receive(:system).with(
            "ruby -I\"lib:test\" #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :bundler option set to true on initialize" do
        subject do
          runner = described_class.new(bundler: true)
          runner
        end

        it "runs with bundler" do
          expect(subject).to receive(:system).with(
            "bundle exec " \
            "ruby -I\"lib:test\" -r bundler/setup #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end
    end

    context "in a folder containing a Gemfile" do
      context "when no :bundler option was given on initialize" do
        subject do
          runner = described_class.new
          runner
        end

        it "runs with bundler" do
          expect(subject).to receive(:system).with(
            "bundle exec " \
            "ruby -I\"lib:test\" -r bundler/setup #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :bundler option set to false on initialize" do
        subject do
          runner = described_class.new(bundler: false)
          runner
        end

        it "runs without bundler" do
          expect(subject).to receive(:system).with(
            "ruby -I\"lib:test\" #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :rubygems option set to true (and :bundler to false) on initialize" do
        subject do
          runner = described_class.new(bundler: false, rubygems: true)
          runner
        end

        it "runs without bundler and require rubygems" do
          expect(subject).to receive(:system).with(
            "ruby -I\"lib:test\" -r rubygems #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when no :runner option was given on initialize" do
        subject do
          runner = described_class.new
          runner
        end

        it "displays message with the tests that will be fired" do
          expect(Guard::Compat::UI).to receive(:info).with(
            "Running: test/unit/error/error_test.rb test/unit/failing_test.rb", reset: true
          )

          dev_null { subject.run(["test/unit/error/error_test.rb", "test/unit/failing_test.rb"]) }
        end

        it "runs with the --runner options set to 'guard' and require default_guard_test_runner" do
          expect(subject).to receive(:system).with(
            "bundle exec " \
            "ruby -I\"lib:test\" -r bundler/setup #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :rvm option is given" do
        subject do
          runner = described_class.new(rvm: ['1.8.7', '1.9.2'])
          runner
        end

        it "runs with rvm exec" do
          expect(subject).to receive(:system).with(
            "rvm 1.8.7,1.9.2 exec " \
            "bundle exec " \
            "ruby -I\"lib:test\" -r bundler/setup #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :include option is given" do
        subject do
          runner = described_class.new(include: %w[foo bar])
          runner
        end

        it "adds the appropriate -I options" do
          expect(subject).to receive(:system).with(
          "bundle exec " \
          "ruby -I\"foo\" -I\"bar\" -r bundler/setup #{guard_test_runner_require}" \
          "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
          "-- --use-color --runner=guard_test"
          )

          subject.run(["test/succeeding_test.rb"])
        end

        context "when the :zeus option is given" do
          subject do
            runner = described_class.new(zeus: true)
            runner
          end

          it "does not add a -I option" do
            expect(subject).to_not receive(:system).with(/\-I\"foo\" \-I\"bar\"/)

            subject.run(["test/succeeding_test.rb"])
          end
        end

        context "when the :spring option is given" do
          subject do
            runner = described_class.new(spring: true)
            runner
          end

          it "does not add a -I option" do
            expect(subject).to_not receive(:system).with(/\-I\"foo\" \-I\"bar\"/)

            subject.run(["test/succeeding_test.rb"])
          end
        end

      end

      context "when the :cli option is given" do
        subject do
          runner = described_class.new(cli: '--pretty')
          runner
        end

        it "adds the cli option at the end of the command" do
          expect(subject).to receive(:system).with(
          "bundle exec " \
          "ruby -I\"lib:test\" -r bundler/setup #{guard_test_runner_require}" \
            "-e \"%w[test/succeeding_test.rb].each { |p| load p }\" " \
            "-- --use-color --runner=guard_test --pretty"
          )

          subject.run(["test/succeeding_test.rb"])
        end
      end

      context "when the :message option is given" do
        it "displays it" do
          expect(Guard::Compat::UI).to receive(:info).with("That test is failing!!!", reset: true)
          runner = described_class.new

          dev_null { runner.run(["test/unit/failing_test.rb"], message: "That test is failing!!!") }
        end
      end

      it "loads and executes all the tests files" do
        runner = described_class.new
        expect(runner).to receive(:system).with(
          "bundle exec " \
          "ruby -I\"lib:test\" -r bundler/setup #{guard_test_runner_require}" \
          "-e \"%w[test/error/error_test.rb test/unit/failing_test.rb].each { |p| load p }\" " \
          "-- --use-color --runner=guard_test"
        )

        runner.run(["test/error/error_test.rb", "test/unit/failing_test.rb"])
      end

    end

  end # #run

end
