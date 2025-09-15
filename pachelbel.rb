require "midi"

# prompt the user to select an input and output

# @input = UniMIDI::Input.gets
@output = UniMIDI::Output.gets

DURATION=60.0/56.0

# the entire cello part
cello=[%w{D3 A2 B2 F#2}.zip([DURATION]*4), %w{G2 D2 G2 A2}.zip([DURATION]*4)]*28 + [["D3", DURATION]]

def phrase_1
  %w{F#5 E5 D5 C#5 B4 A4 B4 C#5}.each { |n| play n, DURATION }
end

def phrase_2
  %w{D5 C#5 B4 A4 G4 F#4 G4 E4}.each { |n| play n, DURATION }
end

t1 = Thread.new do
  MIDI.using(@output) do
    loop do |n|
      %w{D3 A2 B2 F#2 G2 D2 G2 A2}.each { |n| play n, DURATION }
    end
  end
end

t2 = Thread.new do
  MIDI.using(@output) do
    sleep 8*DURATION
    phrase_1
    phrase_2
  end
end

t3 = Thread.new do
  MIDI.using(@output) do
    sleep 16*DURATION
    phrase_1
    phrase_2
  end
end


t1.run
t2.run
t3.run

t1.join
t2.join
t3.join


