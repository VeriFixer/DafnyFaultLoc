// dafny-synthesis_task_id_430.dfy

method {:testEntry} ParabolaDirectrix(a: real, h: real, k: real)
    returns (directrix: real)
  requires a != 0.0
  ensures directrix == k - 1.0 / (4.0 * a)
{
  directrix := 1.0 / (4.0 * a);
}


method {:test} Test0() {
expect 1.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(1.0, 0.0, 1.0);
expect r0 == 1.0 - 1.0 / (4.0 * 1.0);
}

// REPEAT 1 - TIME: 2.3250105 s

method {:test} Test1() {
expect 9.0/8.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(9.0/8.0, 2.0, 9.0/8.0);
expect r0 == 9.0/8.0 - 1.0 / (4.0 * 9.0/8.0);
}

// REPEAT 2 - TIME: 3.0324895 s

method {:test} Test2() {
expect 89.0/72.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(89.0/72.0, 3.0, 89.0/72.0);
expect r0 == 89.0/72.0 - 1.0 / (4.0 * 89.0/72.0);
}

// REPEAT 3 - TIME: 3.8243389 s

method {:test} Test3() {
expect 8569.0/6408.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(8569.0/6408.0, 5.0, 8569.0/6408.0);
expect r0 == 8569.0/6408.0 - 1.0 / (4.0 * 8569.0/6408.0);
}

// REPEAT 4 - TIME: 4.6351232 s

method {:test} Test4() {
expect 78560569.0/54910152.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(78560569.0/54910152.0, 6.0, 78560569.0/54910152.0);
expect r0 == 78560569.0/54910152.0 - 1.0 / (4.0 * 78560569.0/54910152.0);
}

// REPEAT 5 - TIME: 5.3459793 s

method {:test} Test5() {
expect 6548653600686649.0/4313772784996488.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(6548653600686649.0/4313772784996488.0, 7.0, 6548653600686649.0/4313772784996488.0);
expect r0 == 6548653600686649.0/4313772784996488.0 - 1.0 / (4.0 * 6548653600686649.0/4313772784996488.0);
}

// REPEAT 6 - TIME: 6.1280993 s

method {:test} Test6() {
expect 45210943436858257427664058390969.0/28249403681011324897601853488712.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(45210943436858257427664058390969.0/28249403681011324897601853488712.0, 9.0, 45210943436858257427664058390969.0/28249403681011324897601853488712.0);
expect r0 == 45210943436858257427664058390969.0/28249403681011324897601853488712.0 - 1.0 / (4.0 * 45210943436858257427664058390969.0/28249403681011324897601853488712.0);
}

// REPEAT 7 - TIME: 7.0054765 s

method {:test} Test7() {
expect 2143783007492388766249155019896515868626011068468542687949686329.0/1277182191947178457757204252145640427890253310178530169924241928.0 != 0.0, "If this check fails at runtime, the test does not meet the preconditions";
var r0 := ParabolaDirectrix(2143783007492388766249155019896515868626011068468542687949686329.0/1277182191947178457757204252145640427890253310178530169924241928.0, 10.0, 2143783007492388766249155019896515868626011068468542687949686329.0/1277182191947178457757204252145640427890253310178530169924241928.0);
expect r0 == 2143783007492388766249155019896515868626011068468542687949686329.0/1277182191947178457757204252145640427890253310178530169924241928.0 - 1.0 / (4.0 * 2143783007492388766249155019896515868626011068468542687949686329.0/1277182191947178457757204252145640427890253310178530169924241928.0);
}

// REPEAT 8 - TIME: 7.6486614 s
