package com.chtrembl.petstoreapp.service;

import com.microsoft.applicationinsights.TelemetryClient;
import com.microsoft.applicationinsights.telemetry.AvailabilityTelemetry;
import com.microsoft.applicationinsights.telemetry.Duration;
import com.microsoft.applicationinsights.telemetry.EventTelemetry;
import com.microsoft.applicationinsights.telemetry.ExceptionTelemetry;
import com.microsoft.applicationinsights.telemetry.MetricTelemetry;
import com.microsoft.applicationinsights.telemetry.PageViewTelemetry;
import com.microsoft.applicationinsights.telemetry.RemoteDependencyTelemetry;
import com.microsoft.applicationinsights.telemetry.RequestTelemetry;
import com.microsoft.applicationinsights.telemetry.SeverityLevel;
import com.microsoft.applicationinsights.telemetry.Telemetry;
import com.microsoft.applicationinsights.telemetry.TelemetryContext;
import com.microsoft.applicationinsights.telemetry.TraceTelemetry;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.slf4j.MDC;
import org.springframework.stereotype.Component;

import java.util.Date;
import java.util.Map;

/**
 * Custom PetStoreTelemetryClient that works with the modern Application Insights Java agent.
 * In Spring Boot 3 with Application Insights 3.7+, telemetry is automatically collected
 * through the Java agent, so this class primarily provides logging integration.
 */
@Slf4j
@Component
public class PetStoreTelemetryClient extends TelemetryClient {
    @Override
    public void track(Telemetry telemetry) {
        log.info("Custom telemetry tracked: {}", telemetry);
        super.track(telemetry);
    }

    @Override
    public void flush() {
        log.info("Telemetry flush requested");
        super.flush();
    }

    @Override
    public void trackPageView(PageViewTelemetry pageViewTelemetry) {
        log.info("Page view tracked: {}", pageViewTelemetry);
        super.trackPageView(pageViewTelemetry);
    }

    @Override
    public void trackPageView(String name) {
        log.info("Page view: {}", name);
        super.trackPageView(name);
    }

    @Override
    public void trackDependency(String dependencyName, String commandName, Duration duration, boolean success) {
        log.info("Dependency: {} - {} (Success: {})", dependencyName, commandName, success);
        super.trackDependency(dependencyName, commandName, duration, success);
    }

    @Override
    public void trackHttpRequest(String name, Date timestamp, long duration, String responseCode, boolean success) {
        log.info("HTTP Request: {} - {} ms (Response: {}, Success: {})", name, duration, responseCode, success);
        super.trackHttpRequest(name, timestamp, duration, responseCode, success);
    }

    @Override
    public void trackException(Exception exception) {
        log.error("Exception tracked", exception);
        super.trackException(exception);
    }

    @Override
    public void trackException(Exception exception, Map<String, String> properties, Map<String, Double> metrics) {
        if (properties != null) {
            properties.forEach(MDC::put);
        }

        log.error("Exception tracked with properties: {} and metrics: {}", properties, metrics, exception);
        super.trackException(exception, properties, metrics);

        if (properties != null) {
            properties.keySet().forEach(MDC::remove);
        }
    }

    @Override
    public void trackMetric(String name, double value) {
        log.info("Metric: {} = {}", name, value);
        super.trackMetric(name, value);
    }

    @Override
    public void trackMetric(String name, double value, Integer sampleCount, Double min, Double max, Double stdDev, Map<String, String> properties) {
        if (properties != null) {
            properties.forEach(MDC::put);
        }

        log.info("Metric: {} = {} (samples: {}, min: {}, max: {}, stdDev: {}) with properties: {}", name, value, sampleCount, min, max, stdDev, properties);
        super.trackMetric(name, value, sampleCount, min, max, stdDev, properties);

        if (properties != null) {
            properties.keySet().forEach(MDC::remove);
        }
    }

    @Override
    public void trackTrace(String message, SeverityLevel severityLevel) {
        log.info("Trace [{}]: {}", severityLevel, message);
        super.trackTrace(message, severityLevel);
    }

    @Override
    public void trackTrace(String message) {
        log.info("Trace: {}", message);
        super.trackTrace(message);
    }

    @Override
    public void trackTrace(String message, SeverityLevel severityLevel, Map<String, String> properties) {
        if (properties != null) {
            properties.forEach(MDC::put);
        }

        log.info("Trace [{}]: {} with properties: {}", severityLevel, message, properties);
        super.trackTrace(message, severityLevel, properties);

        if (properties != null) {
            properties.keySet().forEach(MDC::remove);
        }
    }

    @Override
    public void trackEvent(String name) {
        log.info("Event: {}", name);
        super.trackEvent(name);
    }

    @Override
    public void trackEvent(String name, Map<String, String> properties, Map<String, Double> metrics) {
        if (properties != null) {
            properties.forEach(MDC::put);
        }

        log.info("Event: {} with properties: {} and metrics: {}", name, properties, metrics);
        super.trackEvent(name, properties, metrics);

        if (properties != null) {
            properties.keySet().forEach(MDC::remove);
        }
    }
}
