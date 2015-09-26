use FindBin;
use lib "$FindBin::Bin/extlib/lib/perl5";
use lib "$FindBin::Bin/lib";
use File::Basename;
use Plack::Builder;
use Isu4Qualifier::Web;
use Plack::Session::State::Cookie;
use Plack::Session::Store::File;
use Sereal;
use Cache::Memcached::Fast;
#use Devel::NYTProf;

my $root_dir = File::Basename::dirname(__FILE__);
my $session_dir = "/tmp/isu4_session_plack";
mkdir $session_dir;

my $decoder = Sereal::Decoder->new();
my $encoder = Sereal::Encoder->new();
my $app = Isu4Qualifier::Web->psgi($root_dir);
builder {
  enable 'ReverseProxy';
  enable 'Static',
    path => qr!^/(?:stylesheets|images)/!,
    root => $root_dir . '/public';
  enable 'Session::Simple',
    store => Cache::Memcached::Fast->new({
       servers => [ { address => "/tmp/memcached.sock", noreply => 0 } ],
       serialize_methods => [ sub { $encoder->encode($_[0])}, 
                              sub { $decoder->decode($_[0])} ],
    }),
    httponly => 1,
    cookie_name => "isu4_session",
    keep_empty => 0;
  ;
  # enable sub {
  #   my $app = shift;
  #     sub {
  #       my $env = shift;
  #       DB::enable_profile();
  #       my $res = $app->($env);
  #       DB::disable_profile();
  #       return $res;
  #     };
  #   };
  # ;
  $app;
};
