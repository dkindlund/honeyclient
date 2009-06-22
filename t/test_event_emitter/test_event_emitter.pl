#!/usr/bin/perl -w

use strict;
use warnings;
use lib qw(blib/lib blib/arch/auto/HoneyClient/Message);
use HoneyClient::Message;
use Data::Dumper;
use Data::UUID;
use HoneyClient::Util::DateTime;
use JSON::XS;
use HoneyClient::Util::EventEmitter;
use Digest::MD5 qw(md5_hex);
use Digest::SHA1 qw(sha1_hex);

# Simulate host creation.
my $host = HoneyClient::Message::Host->new({
    hostname => "honeyclient3.foo.com",
    ip       => "10.0.0.3",
});

HoneyClient::Util::EventEmitter->Host(action => 'find_or_create', message => $host);

my $generator = Data::UUID->new();
my $quick_clone_name = substr(md5_hex($generator->create_str), 0, 26);
my $snapshot_name = substr(md5_hex($generator->create_str), 0, 26);

# Simulate client creation.
my $client = HoneyClient::Message::Client->new({
    quick_clone_name => $quick_clone_name,
    snapshot_name    => $snapshot_name,
    created_at       => HoneyClient::Util::DateTime->now(),
    host             => {
        hostname     => "honeyclient3.foo.com",
        ip           => "10.0.0.3",
    },
    os               => {
        name         => "Windows XP Service Pack 2",
        version      => "5.1.2600.2",
        short_name   => "Microsoft Windows", 
    },
    application      => {
        manufacturer => "Microsoft Corporation",
        version      => "6.0.290.2180",
        short_name   => "Internet Explorer",
    },
    client_status    => {
        status       => "created",
    },
});

HoneyClient::Util::EventEmitter->Client(action => 'find_or_create', message => $client);

# Simulate client status change to running.
$client = HoneyClient::Message::Client->new({
    quick_clone_name => $quick_clone_name,
    snapshot_name    => $snapshot_name,
    client_status    => {
        status       => "running",
    },
});

HoneyClient::Util::EventEmitter->Client(action => 'find_and_update.client_status', message => $client);

# Simulate a new job getting created.
my $job_uuid = lc($generator->create_str());
my $job = HoneyClient::Message::Job->new({
    uuid             => $job_uuid,
    job_source       => {
        name         => "proxy.foo.com",
        protocol     => "http",
    },
    created_at       => HoneyClient::Util::DateTime->now(),
    job_alerts       => [{
        protocol     => "smtp",
        address      => 'admin@foo.com',
    }],
    urls             => [{
        priority     => 10,
        url          => "http://www.bar.com/",
        url_status   => {status => "queued"},
    },{
        priority     => 50,
        url          => "http://www.baz.com/",
        url_status   => {status => "queued"},
    },{
        priority     => 100,
        url          => "http://www.foo.com/",
        url_status   => {status => "queued"},
    }],
});

HoneyClient::Util::EventEmitter->Job(action => 'create.job.urls.job_alerts', message => $job, priority => 0);

# Simulate client obtaining a new job.
$job = HoneyClient::Message::Job->new({
    uuid                 => $job_uuid,
    client               => {
        quick_clone_name => $quick_clone_name,
        snapshot_name    => $snapshot_name,
    },
});

HoneyClient::Util::EventEmitter->Job(action => 'find_and_update.client', message => $job);

# Simulate client visiting URLs in job.
my $time_at = HoneyClient::Util::DateTime->epoch();
$job = HoneyClient::Message::Job->new({
    uuid                     => $job_uuid,
    urls                     => [{
        time_at              => $time_at,
        url                  => "http://www.baz.com/",
        client               => {
            quick_clone_name => $quick_clone_name,
            snapshot_name    => $snapshot_name,
        },
        url_status           => {status => "timed_out"},
    },{
        time_at              => $time_at,
        url                  => "http://www.foo.com/",
        client               => {
            quick_clone_name => $quick_clone_name,
            snapshot_name    => $snapshot_name,
        },
        url_status           => {status => "visited"},
    }],
});

HoneyClient::Util::EventEmitter->Job(action => 'find_and_update.urls.url_status.time_at.client', message => $job);

# Simulate a client encountering a suspicious URL in a job.
$time_at = HoneyClient::Util::DateTime->epoch();
$job = HoneyClient::Message::Job->new({
    uuid                     => $job_uuid,
    completed_at             => HoneyClient::Util::DateTime->now(),
    urls                     => [{
        time_at              => $time_at,
        url                  => "http://www.bar.com/",
        client               => {
            quick_clone_name => $quick_clone_name,
            snapshot_name    => $snapshot_name,
        },
        url_status           => {status => "suspicious"},
    }],
});

HoneyClient::Util::EventEmitter->Job(action => 'find_and_update.completed_at.urls.url_status.time_at.client', message => $job);

# Simulate a new fingerprint getting created.
my $checksum = md5_hex($generator->create_str);
my $fingerprint = HoneyClient::Message::Fingerprint->new({
    url              => {
    # XXX: We assume there are always unique (url,time_at) entries and
    # no such duplicates occur.
        url          => "http://www.bar.com/",
        time_at      => $time_at,
    },
    os_processes     => [{
        name         => 'C:\Program Files\Internet Explorer\iexplore.exe',
        pid          => 9123,
        process_files => [{
            name      => 'C:\WINDOWS\fheueyw.exe',
            event     => "Write",
            time_at   => $time_at,
            file_content => {
                md5      => md5_hex($checksum),
                sha1     => sha1_hex($checksum),
                size     => 23847,
                mime_type => "application/x-ms-dos-executable",
            },
        },{
            name          => 'C:\WINDOWS\notepad.exe',
            event         => "Delete",
            time_at       => $time_at,
        }],
        process_registries => [{
            name           => 'HKLM\SYSTEM\ControlSet001\Control\SecurityProviders',
            event          => "SetValueKey",
            value_name     => "SecurityProviders",
            value_type     => "REG_SZ",
            value          => "msapsspc.dll, schannel.dll, digest.dll, msnsspc.dll, digeste.dll",
            time_at        => $time_at,
        },{
            name           => 'HKLM\SYSTEM\ControlSet002\Control\SecurityProviders',
            event          => "SetValueKey",
            value_name     => "SecurityProviders",
            value_type     => "REG_SZ",
            value          => "msapsspc.dll, schannel.dll, digest.dll, msnsspc.dll, digeste.dll",
            time_at        => $time_at,
        }],
    },{
        name               => 'C:\WINDOWS\fheueyw.exe',
        pid                => 7363,
        parent_name        => 'C:\Program Files\Internet Explorer\iexplore.exe',
        parent_pid         => 9123,
    }],
});

HoneyClient::Util::EventEmitter->Fingerprint(action => 'create.fingerprint.os_processes.process_files.process_registries', message => $fingerprint);

# Simulate client status change to suspicious.
$client = HoneyClient::Message::Client->new({
    quick_clone_name => $quick_clone_name,
    snapshot_name    => $snapshot_name,
    suspended_at     => HoneyClient::Util::DateTime->now(),
    client_status    => {
        status       => "suspicious",
    },
});

HoneyClient::Util::EventEmitter->Client(action => 'find_and_update.client_status.suspended_at', message => $client);
