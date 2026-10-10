def gc_content(seq):
    """Return the GC-content of a DNA sequence."""
    seq = seq.upper()
    gc = (seq.count("G") + seq.count("C"))/len(seq)
    return gc

def reverse_complement(seq):
    """Return the reverse complement of a sequence"""
    seq = seq.upper()
    rv_com = seq.translate(str.maketrans("ACGT", "TGCA"))[::-1]
    return rv_com

def count_base(seq, base="A"):
    """Return the number of a specific base in a given sequence."""
    seq = seq.upper()
    return seq.count(base)

def transcribe(seq):
    """Return the RNA sequence of a given DNA sequence."""
    seq = seq.upper()
    return seq.replace("T", "U")

def check_seq(seq):
    """Checks if the sequence is a DNA sequence or not.
    Returns True or False"""
    seq = seq.upper()
    if set(seq) <= set("ACGT"):
        check = True
    else:
        check = False
    return check
    
def counts(seq, counts = None):
    "Counts all bases and returns a dictionary with the counts."
    counts = {}
    for base in "ACGT":
        counts[base] = count_base(seq, base)
    return counts

def codons(seq, frame=0):
    """Returns all codons in frame (default 0)"""
    codons = []
    for i in range(frame,len(seq),3):
        codons.append(seq[i:i+3])
    return codons

