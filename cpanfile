requires 'perl', '5.010001';

requires 'Encode';
requires 'Moo';
requires 'Text::MeCab';

on 'test' => sub {
    requires 'Test::More', '0.98';
};
