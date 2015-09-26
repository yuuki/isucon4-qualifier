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

my $root_dir = File::Basename::dirname(__FILE__);
my $session_dir = "/tmp/isu4_session_plack";
mkdir $session_dir;

my $decoder = Sereal::Decoder->new();
my $encoder = Sereal::Encoder->new();
my $app = Isu4Qualifier::Web->psgi($root_dir);
builder {
  enable 'Profiler::NYTProf',
    env_nytprof          => 'start=no:sigexit=int:addpid=0:forkdepth=0:file=/tmp/nytprof.out',
    profiling_result_dir => sub { '/tmp' },
    enable_profile       => sub { $$ % 10 == 0 },
    enable_reporting     => 0
  ;
  enable 'ReverseProxy';
  enable 'Static',
    path => qr!^/(?:stylesheets|images)/!,
    root => $root_dir . '/public';
  enable 'Session::Simple',
    store => Cache::Memcached::Fast->new({
       servers => [ { address => "localhost:11211",noreply=>0} ],
       serialize_methods => [ sub { $encoder->encode($_[0])}, 
                              sub { $decoder->decode($_[0])} ],
    }),
    httponly => 1,
    cookie_name => "isu4_session",
    keep_empty => 0;
  ;
  $app;
};
