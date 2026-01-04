<script lang="ts">
    import { Zap, Search, Check, Clock, TrendingUp, TrendingDown, Circle, Target, Ban, Scale, BarChart, MapPin, Compass, Building2, Bot, AlertTriangle, FileText, RefreshCw, ChevronDown, ChevronUp, X, Cpu, Shield, Play, CheckCircle, HelpCircle, ArrowRight, Star, Flame, Zap as ZapIcon } from 'lucide-svelte';

    let symbol: string = "BTCUSDT";
    const entryTimeframe: string = "15m";
    let isLoading: boolean = false;
    let loadingStep: number = 0;
    let result: any = null;
    let meta: any = null;
    let error: string | null = null;
    let analysisTimestamp: string = "";

    let collapsedSections: { [key: string]: boolean } = {
        poi: false,
        cisd: false,
        bias: false,
        structure: false,
        setup: false,
        reasoning: false,
        risk: false,
        summary: false,
        faq1: true,
        faq2: true,
        faq3: true
    };

    // Mock statistics data
    const stats = {
        totalAnalyses: 1234,
        successRate: 87.5,
        activeUsers: 456,
        lastUpdated: new Date().toLocaleString()
    };

    // Quick symbols
    const quickSymbols = [
        "BTCUSDT",
        "ETHUSDT",
        "SOLUSDT",
        "BNBUSDT",
        "XRPUSDT",
        "ADAUSDT"
    ];

    function handleQuickSymbol(quickSymbol: string) {
        symbol = quickSymbol;
        handleAnalyze();
    }

    function getSignalClass(signal: string): string {
        if (signal === "BUY") return "badge-success";
        if (signal === "SELL") return "badge-error";
        return "badge-neutral";
    }

    function getSetupPhaseClass(phase: string): string {
        if (phase === "READY_TO_ENTER") return "badge-success";
        if (phase === "WAITING_FOR_CLOSE") return "badge-warning";
        return "badge-neutral";
    }

    function getBiasClass(biasType: string): string {
        if (biasType.includes("BULLISH")) return "badge-success";
        if (biasType.includes("BEARISH")) return "badge-error";
        return "badge-neutral";
    }

    function getRiskLevelClass(riskLevel: string): string {
        if (riskLevel === "LOW") return "badge-success";
        if (riskLevel === "MEDIUM") return "badge-warning";
        if (riskLevel === "HIGH") return "badge-error";
        return "badge-neutral";
    }

    function toggleSection(section: string) {
        collapsedSections[section] = !collapsedSections[section];
    }

    async function handleAnalyze() {
        isLoading = true;
        loadingStep = 1;
        error = null;
        result = null;
        meta = null;
        collapsedSections = {
            poi: false,
            cisd: false,
            bias: false,
            structure: false,
            setup: false,
            reasoning: false,
            risk: false,
            summary: false,
            faq1: true,
            faq2: true,
            faq3: true
        };

        const loadingInterval = setInterval(() => {
            if (loadingStep < 3) loadingStep++;
        }, 800);

        try {
            const params = new URLSearchParams();
            params.append("symbol", symbol.toUpperCase());
            params.append("timeframe", entryTimeframe);

            const baseUrl = import.meta.env.VITE_API_URL || "";
            const response = await fetch(`${baseUrl}/api/trading/analyze?${params.toString()}`);
            const data = await response.json();

            loadingStep = 3;

            if (data.success) {
                result = data.data;
                meta = data.meta;
                analysisTimestamp = new Date().toLocaleString();
            } else {
                error = data.error || "Failed to fetch data";
            }
        } catch (err: unknown) {
            error = err instanceof Error ? err.message : "Unknown error";
        } finally {
            clearInterval(loadingInterval);
            setTimeout(() => {
                isLoading = false;
                loadingStep = 0;
            }, 500);
        }
    }
</script>

<div class="min-h-screen bg-base-100">
    <div class="container mx-auto px-4 py-8 max-w-7xl">
        <!-- Hero Section -->
        <div class="text-center mb-12 animate-fade-in">
            <div class="flex items-center justify-center gap-2 mb-4">
                <div class="badge badge-primary badge-lg gap-1">
                    <Cpu class="w-4 h-4" />
                    AI-Powered
                </div>
                <div class="badge badge-secondary badge-lg gap-1">
                    <Flame class="w-4 h-4" />
                    Real-time Analysis
                </div>
            </div>
            <h1 class="text-6xl font-bold bg-gradient-to-r from-primary via-secondary to-accent bg-clip-text text-transparent mb-4">
                Sentor Trade
            </h1>
            <p class="text-xl text-base-content/70 max-w-2xl mx-auto mb-6">
                Advanced Fractal Model Trading Analysis powered by AI. Get accurate BUY/SELL signals with precise entry, stop loss, and take profit levels.
            </p>
            <div class="flex items-center justify-center gap-2 text-base-content/60">
                <Star class="w-5 h-5 text-warning fill-current" />
                <span>Trusted by {stats.activeUsers.toLocaleString()} traders</span>
                <span>•</span>
                <span>{stats.successRate}% success rate</span>
            </div>
        </div>

        <!-- Features Section -->
        <div class="grid gap-6 md:grid-cols-2 lg:grid-cols-4 mb-12">
            <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1">
                <div class="card-body text-center">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-primary/10 flex items-center justify-center">
                        <Target class="w-8 h-8 text-primary" />
                    </div>
                    <h3 class="text-lg font-bold mb-2">Accurate Signals</h3>
                    <p class="text-sm text-base-content/70">High confidence BUY/SELL signals based on fractal pattern analysis</p>
                </div>
            </div>

            <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1">
                <div class="card-body text-center">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-secondary/10 flex items-center justify-center">
                        <BarChart class="w-8 h-8 text-secondary" />
                    </div>
                    <h3 class="text-lg font-bold mb-2">Multi-Timeframe</h3>
                    <p class="text-sm text-base-content/70">Analyze across bias, structure, and entry timeframes for precision</p>
                </div>
            </div>

            <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1">
                <div class="card-body text-center">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-accent/10 flex items-center justify-center">
                        <Shield class="w-8 h-8 text-accent" />
                    </div>
                    <h3 class="text-lg font-bold mb-2">Smart Risk Mgmt</h3>
                    <p class="text-sm text-base-content/70">Automatic stop loss, take profit, and risk:reward calculation</p>
                </div>
            </div>

            <div class="card bg-base-100 shadow-xl hover:shadow-2xl transition-all duration-300 transform hover:-translate-y-1">
                <div class="card-body text-center">
                    <div class="w-16 h-16 mx-auto mb-4 rounded-full bg-error/10 flex items-center justify-center">
                        <Bot class="w-8 h-8 text-error" />
                    </div>
                    <h3 class="text-lg font-bold mb-2">AI Reasoning</h3>
                    <p class="text-sm text-base-content/70">Detailed explanations for every trading decision and signal</p>
                </div>
            </div>
        </div>

        <!-- Main Analysis Card -->
        <div class="card bg-base-100 shadow-2xl border-2 border-primary/20 mb-12 animate-slide-up">
            <div class="card-body">
                <h2 class="card-title text-2xl font-bold mb-6 flex items-center gap-2">
                    <ZapIcon class="w-6 h-6 text-primary" />
                    Start Your Analysis
                </h2>

                <div class="form-control">
                    <label class="label" for="symbol">
                        <span class="label-text font-semibold text-base">Trading Symbol</span>
                    </label>
                    <input
                        type="text"
                        id="symbol"
                        placeholder="BTCUSDT"
                        bind:value={symbol}
                        class="input input-bordered input-lg w-full focus:ring-2 focus:ring-primary"
                    />
                    <label class="label">
                        <span class="label-text-alt">Enter Binance trading pair (e.g., BTCUSDT, ETHUSDT, SOLUSDT)</span>
                    </label>
                </div>

                <!-- Quick Symbols -->
                <div class="mt-6">
                    <label class="label">
                        <span class="label-text font-semibold">Quick Select</span>
                    </label>
                    <div class="flex flex-wrap gap-2">
                        {#each quickSymbols as quickSymbol}
                            <button
                                on:click={() => handleQuickSymbol(quickSymbol)}
                                class="btn btn-sm btn-outline gap-1 hover:btn-primary"
                            >
                                <Play class="w-3 h-3" />
                                {quickSymbol}
                            </button>
                        {/each}
                    </div>
                </div>

                <button
                    on:click={handleAnalyze}
                    disabled={isLoading}
                    class="btn btn-primary btn-lg w-full mt-6 gap-2"
                >
                    {#if isLoading}
                        <span class="loading loading-spinner"></span>
                        Analyzing Market...
                    {:else}
                        <Search class="w-5 h-5" />
                        Analyze Now
                    {/if}
                </button>
            </div>
        </div>

        <!-- Statistics Dashboard -->
        <div class="grid gap-6 md:grid-cols-3 mb-12">
            <div class="stat bg-base-100 shadow-xl rounded-2xl">
                <div class="stat-title text-base-content/70">Total Analyses</div>
                <div class="stat-value text-primary">{stats.totalAnalyses.toLocaleString()}</div>
                <div class="stat-desc">Across all markets</div>
            </div>

            <div class="stat bg-base-100 shadow-xl rounded-2xl">
                <div class="stat-title text-base-content/70">Success Rate</div>
                <div class="stat-value text-secondary">{stats.successRate}%</div>
                <div class="stat-desc">Average accuracy</div>
            </div>

            <div class="stat bg-base-100 shadow-xl rounded-2xl">
                <div class="stat-title text-base-content/70">Active Traders</div>
                <div class="stat-value text-accent">{stats.activeUsers.toLocaleString()}</div>
                <div class="stat-desc">Using Sentor today</div>
            </div>
        </div>

        <!-- How It Works Section -->
        <div class="mb-12">
            <h2 class="text-3xl font-bold text-center mb-8">How It Works</h2>
            <div class="grid gap-6 md:grid-cols-3">
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-12 h-12 rounded-full bg-primary text-primary-content flex items-center justify-center text-xl font-bold">1</div>
                            <CheckCircle class="w-8 h-8 text-primary" />
                        </div>
                        <h3 class="card-title">Enter Symbol</h3>
                        <p class="text-base-content/70">Input any Binance trading pair you want to analyze. Use quick select for popular options.</p>
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-12 h-12 rounded-full bg-secondary text-secondary-content flex items-center justify-center text-xl font-bold">2</div>
                            <Bot class="w-8 h-8 text-secondary" />
                        </div>
                        <h3 class="card-title">AI Analysis</h3>
                        <p class="text-base-content/70">Our AI analyzes fractal patterns across multiple timeframes and detects optimal entry points.</p>
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <div class="flex items-center gap-4 mb-4">
                            <div class="w-12 h-12 rounded-full bg-accent text-accent-content flex items-center justify-center text-xl font-bold">3</div>
                            <Target class="w-8 h-8 text-accent" />
                        </div>
                        <h3 class="card-title">Get Results</h3>
                        <p class="text-base-content/70">Receive actionable trade signals with entry, stop loss, take profit, and detailed AI reasoning.</p>
                    </div>
                </div>
            </div>
        </div>

        {#if isLoading}
            <div class="card bg-base-100 shadow-xl mb-8 animate-pulse">
                <div class="card-body">
                    <div class="flex flex-col items-center justify-center py-8">
                        <div class="flex items-center gap-4 mb-6">
                            <div class="w-3 h-3 rounded-full {loadingStep >= 1 ? 'bg-primary' : 'bg-base-300'} transition-colors duration-300"></div>
                            <div class="w-16 h-1 bg-base-300 rounded">
                                <div class="h-full bg-primary rounded transition-all duration-300" style="width: {loadingStep >= 1 ? '100%' : '0%'}"></div>
                            </div>
                            <div class="w-3 h-3 rounded-full {loadingStep >= 2 ? 'bg-primary' : 'bg-base-300'} transition-colors duration-300"></div>
                            <div class="w-16 h-1 bg-base-300 rounded">
                                <div class="h-full bg-primary rounded transition-all duration-300" style="width: {loadingStep >= 2 ? '100%' : '0%'}"></div>
                            </div>
                            <div class="w-3 h-3 rounded-full {loadingStep >= 3 ? 'bg-primary' : 'bg-base-300'} transition-colors duration-300"></div>
                        </div>
                        <p class="text-lg font-semibold">
                            {loadingStep === 1 ? 'Fetching market data...' : loadingStep === 2 ? 'Analyzing fractal patterns...' : 'Calculating signals...'}
                        </p>
                        <p class="text-sm text-base-content/60 mt-2">This may take a few moments</p>
                    </div>
                </div>
            </div>
        {/if}

        {#if error}
            <div class="alert alert-error shadow-lg mb-8 animate-slide-up">
                <X class="w-6 h-6 shrink-0 stroke-current" />
                <div>
                    <h3 class="font-bold">Analysis Failed</h3>
                    <span class="text-sm">{error}</span>
                </div>
            </div>
        {/if}

        {#if result && meta && !isLoading}
            <div class="space-y-6 animate-fade-in">
                <div class="flex justify-between items-center">
                    <h2 class="text-3xl font-bold">
                        Analysis Results
                    </h2>
                    <span class="text-sm text-base-content/60">
                        {analysisTimestamp}
                    </span>
                </div>

                <div class="card bg-base-100 shadow-xl text-base-content overflow-hidden">
                    <div class="card-body">
                        <div class="grid gap-4 md:grid-cols-5">
                            <div class="text-center p-4 bg-base-200 rounded-xl">
                                <div class="text-sm opacity-70 mb-1">Current Price</div>
                                <div class="text-2xl font-bold">
                                    {result.marketData.currentPrice.toLocaleString()}
                                </div>
                                <div class="text-xs mt-1 {result.marketData.priceChangePercent > 0 ? 'text-success' : 'text-error'}">
                                    {result.marketData.priceChangePercent > 0 ? '+' : ''}
                                    {result.marketData.priceChangePercent.toFixed(2)}%
                                </div>
                            </div>

                            <div class="text-center p-4 bg-base-200 rounded-xl">
                                <div class="text-sm opacity-70 mb-1">Signal</div>
                                <div class="text-3xl font-bold">
                                    <span class={`badge ${getSignalClass(result.signal.signal)} badge-lg`}>
                                        {result.signal.signal}
                                    </span>
                                </div>
                                <div class="text-xs mt-1 opacity-70">
                                    Confidence: {result.signal.confidence.toFixed(1)}%
                                </div>
                            </div>

                            {#if meta.fractalData?.dailyBias}
                                <div class="text-center p-4 bg-base-200 rounded-xl">
                                    <div class="text-sm opacity-70 mb-1">Setup Phase</div>
                                    <div class="text-lg font-bold">
                                        <span class={`badge ${getSetupPhaseClass(meta.setupPhase)} badge-lg`}>
                                            {meta.setupPhase}
                                        </span>
                                    </div>
                                    <div class="text-xs mt-1 opacity-70 flex items-center justify-center gap-1">
                                        {#if meta.setupPhase === "READY_TO_ENTER"}
                                            <Check class="w-3 h-3" /> Ready
                                        {:else}
                                            <Clock class="w-3 h-3" /> Waiting
                                        {/if}
                                    </div>
                                </div>

                                <div class="text-center p-4 bg-base-200 rounded-xl">
                                    <div class="text-sm opacity-70 mb-1">Daily Bias</div>
                                    <div class="text-lg font-bold">
                                        <span class={`badge ${getBiasClass(meta.fractalData.dailyBias.type)} badge-lg`}>
                                            {meta.fractalData.dailyBias.type}
                                        </span>
                                    </div>
                                    <div class="text-xs mt-1 opacity-70 flex items-center justify-center gap-1">
                                        {#if meta.fractalData.dailyBias.type.includes("BULLISH")}
                                            <TrendingUp class="w-3 h-3" /> Bullish
                                        {:else}
                                            <TrendingDown class="w-3 h-3" /> Bearish
                                        {/if}
                                    </div>
                                </div>
                            {/if}

                            <div class="text-center p-4 bg-base-200 rounded-xl">
                                <div class="text-sm opacity-70 mb-1">Risk Level</div>
                                <div class="text-2xl flex justify-center items-center gap-2">
                                    <Circle class="w-6 h-6 {meta.riskLevel === 'LOW' ? 'text-success' : meta.riskLevel === 'MEDIUM' ? 'text-warning' : 'text-error'}" fill={meta.riskLevel === 'LOW' ? 'currentColor' : meta.riskLevel === 'MEDIUM' ? 'currentColor' : 'currentColor'} />
                                </div>
                                <div class="text-xs mt-1 font-bold">
                                    {meta.riskLevel}
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                {#if meta.tradeParameters}
                    <div class="card bg-base-100 shadow-xl border-l-4 border-primary overflow-hidden">
                        <div class="card-body">
                            <h3 class="text-xl font-bold mb-6 flex items-center gap-2">
                                <Target class="w-6 h-6 text-primary" />
                                Trade Execution Parameters
                            </h3>

                            <div class="grid gap-4 md:grid-cols-4">
                                <div class="p-4 bg-base-200 rounded-xl">
                                    <div class="flex items-center gap-2 mb-2">
                                        <MapPin class="w-5 h-5 text-primary" />
                                        <span class="text-sm font-semibold">Entry Zone</span>
                                    </div>
                                    <div class="text-3xl font-bold text-primary">
                                        {meta.tradeParameters.entryZone.toFixed(2)}
                                    </div>
                                    <div class="text-xs text-base-content/60 mt-1">Optimal entry price</div>
                                </div>

                                <div class="p-4 bg-base-200 rounded-xl">
                                    <div class="flex items-center gap-2 mb-2">
                                        <Ban class="w-5 h-5 text-error" />
                                        <span class="text-sm font-semibold">Stop Loss</span>
                                    </div>
                                    <div class="text-3xl font-bold text-error">
                                        {meta.tradeParameters.stopLoss.toFixed(2)}
                                    </div>
                                    <div class="text-xs text-base-content/60 mt-1">Risk management</div>
                                </div>

                                <div class="p-4 bg-base-200 rounded-xl">
                                    <div class="flex items-center gap-2 mb-2">
                                        <Target class="w-5 h-5 text-success" />
                                        <span class="text-sm font-semibold">Take Profit</span>
                                    </div>
                                    <div class="text-3xl font-bold text-success">
                                        {meta.tradeParameters.takeProfit.toFixed(2)}
                                    </div>
                                    <div class="text-xs text-base-content/60 mt-1">Target price</div>
                                </div>

                                <div class="p-4 bg-base-200 rounded-xl">
                                    <div class="flex items-center gap-2 mb-2">
                                        <Scale class="w-5 h-5 text-secondary" />
                                        <span class="text-sm font-semibold">Risk:Reward</span>
                                    </div>
                                    <div class="text-3xl font-bold text-secondary">
                                        1:{meta.tradeParameters.riskReward.toFixed(2)}
                                    </div>
                                    <div class="flex items-center gap-2 mt-2">
                                        {#if meta.tradeParameters.riskReward >= 2}
                                            <div class="badge badge-success badge-sm gap-1">
                                                <Check class="w-3 h-3" /> Excellent
                                            </div>
                                        {:else if meta.tradeParameters.riskReward >= 1.5}
                                            <div class="badge badge-warning badge-sm gap-1">
                                                <AlertTriangle class="w-3 h-3" /> Acceptable
                                            </div>
                                        {:else}
                                            <div class="badge badge-error badge-sm gap-1">
                                                <X class="w-3 h-3" /> Poor
                                            </div>
                                        {/if}
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                {/if}

                <div class="grid gap-6 md:grid-cols-2">
                    <div class="card bg-base-100 shadow-xl">
                        <div class="card-body">
                            <h3 class="text-xl font-bold mb-4 flex items-center gap-2">
                                <BarChart class="w-6 h-6" />
                                Confidence & Risk Metrics
                            </h3>

                            <div class="space-y-4">
                                <div>
                                    <div class="flex justify-between items-center mb-2">
                                        <span class="text-sm font-semibold">Signal Confidence</span>
                                        <span class="text-sm font-bold text-primary">{result.signal.confidence.toFixed(1)}%</span>
                                    </div>
                                    <div class="w-full bg-base-300 rounded-full h-3 overflow-hidden">
                                        <div class="bg-primary h-3 rounded-full transition-all duration-1000" style="width: {result.signal.confidence}%"></div>
                                    </div>
                                </div>

                                <div>
                                    <div class="flex justify-between items-center mb-2">
                                        <span class="text-sm font-semibold">Risk Level</span>
                                        <span class={`text-sm font-bold ${meta.riskLevel === 'LOW' ? 'text-success' : meta.riskLevel === 'MEDIUM' ? 'text-warning' : 'text-error'}`}>
                                            {meta.riskLevel}
                                        </span>
                                    </div>
                                    <div class="w-full bg-base-300 rounded-full h-3 overflow-hidden">
                                        <div class={`h-3 rounded-full transition-all duration-1000 ${meta.riskLevel === 'LOW' ? 'bg-success' : meta.riskLevel === 'MEDIUM' ? 'bg-warning' : 'bg-error'}`} style="width: {meta.riskLevel === 'LOW' ? '33%' : meta.riskLevel === 'MEDIUM' ? '66%' : '100%'}"></div>
                                    </div>
                                </div>

                                {#if meta.tradeParameters}
                                    <div>
                                        <div class="flex justify-between items-center mb-2">
                                            <span class="text-sm font-semibold">Risk:Reward Ratio</span>
                                            <span class="text-sm font-bold text-secondary">1:{meta.tradeParameters.riskReward.toFixed(2)}</span>
                                        </div>
                                        <div class="w-full bg-base-300 rounded-full h-3 overflow-hidden">
                                            <div class="bg-secondary h-3 rounded-full transition-all duration-1000" style="width: {Math.min(meta.tradeParameters.riskReward * 33.33, 100)}%"></div>
                                        </div>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>

                    <div class="card bg-base-100 shadow-xl">
                        <div class="card-body">
                            <h3 class="text-xl font-bold mb-4 flex items-center gap-2">
                                <Clock class="w-6 h-6" />
                                Timeframe Alignment
                            </h3>

                            <div class="space-y-3">
                                {#if meta.timeframes}
                                    <div class="flex items-center justify-between p-3 bg-base-200 rounded-lg">
                                        <div class="flex items-center gap-2">
                                            <div class="w-2 h-2 bg-primary rounded-full"></div>
                                            <span class="text-sm font-semibold">Bias Timeframe</span>
                                        </div>
                                        <span class="text-lg font-bold text-primary">{meta.timeframes.bias}</span>
                                    </div>

                                    <div class="flex items-center justify-between p-3 bg-base-200 rounded-lg">
                                        <div class="flex items-center gap-2">
                                            <div class="w-2 h-2 bg-secondary rounded-full"></div>
                                            <span class="text-sm font-semibold">Structure Timeframe</span>
                                        </div>
                                        <span class="text-lg font-bold text-secondary">{meta.timeframes.structure}</span>
                                    </div>

                                    <div class="flex items-center justify-between p-3 bg-base-200 rounded-lg">
                                        <div class="flex items-center gap-2">
                                            <div class="w-2 h-2 bg-accent rounded-full"></div>
                                            <span class="text-sm font-semibold">Entry Timeframe</span>
                                        </div>
                                        <span class="text-lg font-bold text-accent">{meta.timeframes.entry}</span>
                                    </div>
                                {/if}
                            </div>
                        </div>
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('poi')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <MapPin class="w-6 h-6" />
                                Points of Interest (POI)
                            </h3>
                            {#if collapsedSections.poi}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.poi}
                            <div class="mt-4 transition-all duration-300">
                                {#if meta.fractalData?.poi?.length > 0}
                                    <div class="grid gap-3 md:grid-cols-2 lg:grid-cols-3">
                                        {#each meta.fractalData.poi.slice(0, 9) as poi}
                                            <div class="p-3 bg-base-200 rounded-lg">
                                                <div class="flex justify-between items-center mb-2">
                                                    <span class="font-semibold text-sm">{poi.type}</span>
                                                    <span class="text-xs px-2 py-1 rounded-full badge badge-outline">
                                                        {poi.price.toFixed(4)}
                                                    </span>
                                                </div>
                                            </div>
                                        {/each}
                                    </div>
                                {:else}
                                    <div class="p-8 text-center text-base-content/60">
                                        <Search class="w-12 h-12 mx-auto mb-4 opacity-50" />
                                        <p>No points of interest detected</p>
                                    </div>
                                {/if}
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('cisd')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <BarChart class="w-6 h-6" />
                                Recent CISD Events
                            </h3>
                            {#if collapsedSections.cisd}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.cisd}
                            <div class="mt-4 transition-all duration-300">
                                {#if meta.fractalData?.cisds?.length > 0}
                                    <div class="space-y-3">
                                        {#each meta.fractalData.cisds.slice(-5).reverse() as cisd}
                                            <div class="p-4 bg-base-200 rounded-lg">
                                                <div class="flex items-start gap-3">
                                                    <span class={`badge ${cisd.type === "BULLISH" ? "badge-success" : "badge-error"} badge-sm gap-1`}>
                                                        {#if cisd.type === "BULLISH"}
                                                            <TrendingUp class="w-3 h-3" />
                                                        {:else}
                                                            <TrendingDown class="w-3 h-3" />
                                                        {/if}
                                                        {cisd.type}
                                                    </span>
                                                    <div class="flex-1">
                                                        <p class="text-sm">{cisd.description}</p>
                                                    </div>
                                                </div>
                                            </div>
                                        {/each}
                                    </div>
                                {:else}
                                    <div class="p-8 text-center text-base-content/60">
                                        <BarChart class="w-12 h-12 mx-auto mb-4 opacity-50" />
                                        <p>No recent CISD events detected</p>
                                    </div>
                                {/if}
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('bias')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <Compass class="w-6 h-6" />
                                Bias Analysis
                            </h3>
                            {#if collapsedSections.bias}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.bias}
                            <div class="mt-4 transition-all duration-300 space-y-4">
                                <div class="p-4 bg-base-200 rounded-lg">
                                    <p class="text-sm leading-relaxed">{meta.biasAnalysis}</p>
                                </div>

                                {#if meta.fractalData?.dailyBias}
                                    <div class="p-4 bg-base-200 rounded-lg">
                                        <p class="text-sm font-semibold mb-3">
                                            {meta.fractalData.dailyBias.description}
                                        </p>
                                        <div class="flex gap-6 text-sm">
                                            <div class="flex items-center gap-2">
                                                <TrendingUp class="w-4 h-4 text-success" />
                                                <span>Prev High: {meta.fractalData.dailyBias.previousDay.high.toFixed(2)}</span>
                                            </div>
                                            <div class="flex items-center gap-2">
                                                <TrendingDown class="w-4 h-4 text-error" />
                                                <span>Prev Low: {meta.fractalData.dailyBias.previousDay.low.toFixed(2)}</span>
                                            </div>
                                        </div>
                                    </div>
                                {/if}
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('structure')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <Building2 class="w-6 h-6" />
                                Structure Validation
                            </h3>
                            {#if collapsedSections.structure}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.structure}
                            <div class="mt-4 transition-all duration-300">
                                <div class="p-4 bg-base-200 rounded-lg">
                                    <p class="text-sm leading-relaxed">{meta.structureValidation}</p>
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('setup')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <Check class="w-6 h-6" />
                                Setup Confirmation
                            </h3>
                            {#if collapsedSections.setup}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.setup}
                            <div class="mt-4 transition-all duration-300">
                                <div class="p-4 bg-base-200 rounded-lg">
                                    <p class="text-sm leading-relaxed">{meta.setupConfirmation}</p>
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('reasoning')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <Bot class="w-6 h-6" />
                                AI Reasoning
                            </h3>
                            {#if collapsedSections.reasoning}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.reasoning}
                            <div class="mt-4 transition-all duration-300">
                                <div class="p-4 bg-base-200 rounded-lg">
                                    <p class="text-sm leading-relaxed">{result.signal.reasoning}</p>
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('risk')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <AlertTriangle class="w-6 h-6" />
                                Risk Considerations
                            </h3>
                            {#if collapsedSections.risk}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.risk}
                            <div class="mt-4 transition-all duration-300">
                                <div class="p-4 bg-base-200 rounded-lg">
                                    <p class="text-sm leading-relaxed">{meta.riskConsiderations}</p>
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl overflow-hidden">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('summary')}>
                            <h3 class="text-xl font-bold flex items-center gap-2">
                                <FileText class="w-6 h-6" />
                                Market Summary
                            </h3>
                            {#if collapsedSections.summary}
                                <ChevronDown class="w-5 h-5 transition-transform duration-300" />
                            {:else}
                                <ChevronUp class="w-5 h-5 transition-transform duration-300" />
                            {/if}
                        </div>

                        {#if !collapsedSections.summary}
                            <div class="mt-4 transition-all duration-300">
                                <div class="p-4 bg-base-200 rounded-lg">
                                    <p class="text-sm leading-relaxed">{meta.marketSummary}</p>
                                </div>
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="text-center py-8">
                    <button
                        on:click={handleAnalyze}
                        class="btn btn-outline btn-lg gap-2"
                    >
                        <RefreshCw class="w-5 h-5" />
                        Analyze Again
                    </button>
                </div>
            </div>
        {/if}

        <!-- FAQ Section -->
        <div class="mb-12">
            <h2 class="text-3xl font-bold text-center mb-8 flex items-center justify-center gap-2">
                <HelpCircle class="w-8 h-8" />
                Frequently Asked Questions
            </h2>

            <div class="space-y-4 max-w-3xl mx-auto">
                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('faq1')}>
                            <h3 class="text-lg font-bold flex items-center gap-2">
                                <CheckCircle class="w-5 h-5 text-primary" />
                                What is fractal trading analysis?
                            </h3>
                            {#if collapsedSections.faq1}
                                <ChevronDown class="w-5 h-5" />
                            {:else}
                                <ChevronUp class="w-5 h-5" />
                            {/if}
                        </div>
                        {#if !collapsedSections.faq1}
                            <div class="mt-4 pt-4 border-t border-base-300">
                                <p class="text-base-content/80">Fractal trading analysis identifies repeating patterns across different timeframes to predict price movements. Our AI analyzes these patterns to generate high-probability trade signals.</p>
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('faq2')}>
                            <h3 class="text-lg font-bold flex items-center gap-2">
                                <Shield class="w-5 h-5 text-secondary" />
                                How accurate are the trade signals?
                            </h3>
                            {#if collapsedSections.faq2}
                                <ChevronDown class="w-5 h-5" />
                            {:else}
                                <ChevronUp class="w-5 h-5" />
                            {/if}
                        </div>
                        {#if !collapsedSections.faq2}
                            <div class="mt-4 pt-4 border-t border-base-300">
                                <p class="text-base-content/80">Our signals have an average accuracy of {stats.successRate}%. However, market conditions can change rapidly. Always use proper risk management and consider signals as part of your overall trading strategy.</p>
                            </div>
                        {/if}
                    </div>
                </div>

                <div class="card bg-base-100 shadow-xl">
                    <div class="card-body">
                        <div class="flex items-center justify-between cursor-pointer" on:click={() => toggleSection('faq3')}>
                            <h3 class="text-lg font-bold flex items-center gap-2">
                                <Clock class="w-5 h-5 text-accent" />
                                Which timeframes are used in the analysis?
                            </h3>
                            {#if collapsedSections.faq3}
                                <ChevronDown class="w-5 h-5" />
                            {:else}
                                <ChevronUp class="w-5 h-5" />
                            {/if}
                        </div>
                        {#if !collapsedSections.faq3}
                            <div class="mt-4 pt-4 border-t border-base-300">
                                <p class="text-base-content/80">We analyze across three timeframes: Bias timeframe (4h), Structure timeframe (1h), and Entry timeframe (15m). This multi-timeframe approach ensures signals are aligned with the broader market trend while identifying precise entry points.</p>
                            </div>
                        {/if}
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<style>
    @keyframes fade-in {
        from {
            opacity: 0;
        }
        to {
            opacity: 1;
        }
    }

    @keyframes slide-up {
        from {
            opacity: 0;
            transform: translateY(20px);
        }
        to {
            opacity: 1;
            transform: translateY(0);
        }
    }

    .animate-fade-in {
        animation: fade-in 0.6s ease-out;
    }

    .animate-slide-up {
        animation: slide-up 0.6s ease-out;
    }
</style>
