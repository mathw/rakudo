=item ResizablePMCArray.list

This version of list morphs a ResizablePMCArray into a List.

=cut

.namespace ['ResizablePMCArray']
.sub 'list' :method :subid('')
    ##  this code morphs a ResizablePMCArray into a List
    ##  without causing a clone of any of the elements
    $P0 = new 'ResizablePMCArray'
    splice $P0, self, 0, 0
    $P1 = new 'List'
    copy self, $P1
    splice self, $P0, 0, 0
    .return (self)
.end


## special method to cast Parrot String into Rakudo Str.
.namespace ['String']
.sub 'Scalar' :method
    $P0 = new 'Str'
    assign $P0, self
    copy self, $P0
    .return (self)
.end


=item count()

Return the number of required and optional parameters for a Block.
Note that we currently do this by adding the method to Parrot's
"Sub" PMC, so that it works for non-Rakudo subs.

=cut

.namespace ['Sub']
.sub 'count' :method
    $P0 = inspect self, "pos_required"
    $P1 = inspect self, "pos_optional"
    add $P0, $P1
    .return ($P0)
.end


.namespace []
# work around a parrot bug.
.sub 'load-language'
    .param string lang
    load_language lang
.end


# Twiddle MultiSub - at most of these can go away when it stops inheriting
# from RPA.

.namespace ['MultiSub']

.sub 'Scalar' :method
    .return (self)
.end

.sub 'perl' :method
    .return ('{ ... }')
.end

=item name

Gets the name of the routine.

=cut

.sub 'name' :method
    # We'll just use the name of the first candidate.
    $S0 = ''
    $P0 = self[0]
    if null $P0 goto done
    $S0 = $P0
  done:
    .return ($S0)
.end


=item Class.attriter

Return an iterator that iterates over a Class' attributes.
If the Class object has a @!attribute_list property, use
that as the order of attributes, otherwise introspect the
class and use its list.  (As of Parrot 1.4.0 we can't
always introspect the class directly, as the order of
attributes in the class isn't guaranteed.)

=cut

.namespace ['Class']
.sub 'attriter' :method
    $P0 = getprop '@!attribute_list', self
    unless null $P0 goto have_list
    $P0 = inspect self, 'attributes'
  have_list:
    $P1 = iter $P0
    .return ($P1)
.end
